class Admin::UsersController < ApplicationController
  def new
  end

  def edit
  end

  def show
  end

  def index
    @users = User.all
  end
end
