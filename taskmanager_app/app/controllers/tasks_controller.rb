class TasksController < ApplicationController
  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    task = Task.find(params[:id])
    task.update(task_params)
    redirect_to(task_url, notice: t('helpers.edit.notice', name: task.name))
  end

  def create
    task = Task.new(task_params)
    task.save!
    redirect_to(tasks_url, notice: t('helpers.create.notice', name: task.name))
  end

  private

  def task_params
    params.require(:task).permit(:name, :description)
  end
end
