class LabelsController < ApplicationController
  def index
    @labels = current_user.labels
  end

  def new
    @label = Label.new
  end

  def create
    @label = current_user.labels.new(label_params)
    if @label.save
      redirect_to(labels_path, notice: t(".create.notice", name: @label.name))
    else
      render(:new)
    end
  end

  def edit
    @label = current_user.labels.find(params[:id])
  end

  def update
    @label = current_user.labels.find(params[:id])
    if @label.update(label_params)
      redirect_to(labels_path, notice: t(".notice", name: @label.name))
    else
      render(:edit)
    end
  end

  def destroy
    @label = current_user.labels.find(params[:id])
    @label.destroy!
    redirect_to(labels_path, notice: t(".notice", name: @label.name))
  end

  private

    def label_params
      params.require(:label).permit(:name)
    end
end
