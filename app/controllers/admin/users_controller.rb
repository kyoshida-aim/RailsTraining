class Admin::UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to(admin_users_path, notice: t(".register.success", user: @user.login_id))
    else
      render(:new)
    end
  end

  def edit
  end

  def show
  end

  def index
    @users = User.all
  end

  private

    def user_params
      params.require(:user).permit(:login_id, :admin, :password, :password_confirmation)
    end
end
