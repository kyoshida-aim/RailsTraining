class TasksController < ApplicationController
  def index
    # ransackにより受け渡されるパラメータ:qによってソート
    @q = Task.all.order(created_at: :desc).ransack(params[:q])
    @tasks = @q.result
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
    @task = Task.find(params[:id])
    if @task.update(task_params)
      redirect_to(task_url, notice: t("helpers.edit.notice", name: @task.name))
    else
      render :edit
    end
  end

  def destroy
    task = Task.find(params[:id])
    task.destroy!
    redirect_to(tasks_url, notice: t("helpers.delete.notice", name: task.name))
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to(@task, notice: t("helpers.create.notice", name: @task.name))
    else
      render :new
    end
  end

  private

    def task_params
      params.require(:task).permit(:name, :description, :deadline)
    end
end