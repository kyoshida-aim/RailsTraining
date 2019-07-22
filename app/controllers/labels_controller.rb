class LabelsController < ApplicationController
  def index
    @labels = current_user.labels
  end

  def show
  end

  def new
  end

  def edit
  end
end
