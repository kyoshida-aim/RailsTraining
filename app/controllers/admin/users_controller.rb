class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params_create)

    if @user.save
      redirect_to(admin_users_path, notice: t(".register.success", user: @user.login_id))
    else
      render(:new)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params_edit)
      redirect_to(admin_user_path(@user), notice: t(".update.success", user: @user.login_id))
    else
      render(:new)
    end
  end

  private

    def user_params_create
      params.require(:user).permit(:login_id, :admin, :password, :password_confirmation)
    end

    def user_params_edit
      params.require(:user).permit(:admin)
    end
end
