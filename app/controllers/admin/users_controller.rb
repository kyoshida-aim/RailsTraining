class Admin::UsersController < ApplicationController
  def index
    @users = User.all.includes(:tasks)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_params)

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

    if @user.update(edit_params)
      redirect_to(admin_users_path, notice: t(".update.success", user: @user.login_id))
    else
      render(:edit)
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy!
    redirect_to(admin_users_url, notice: t(".destroy.success", user: @user.login_id))
  end

  private

    def create_params
      params.require(:user).permit(:login_id, :admin, :password, :password_confirmation)
    end

    def edit_params
      params.require(:user).permit(:admin)
    end
end
