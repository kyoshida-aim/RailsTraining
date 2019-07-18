class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to(login_path, notice: t(".register.success", user: @user.login_id))
    else
      render(:new)
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to(tasks_path, notice: t("helpers.user.edit.notice"))
    else
      render(:edit)
    end
  end

  private

    def user_params
      params.require(:user).permit(:login_id, :password, :password_confirmation)
    end
end
