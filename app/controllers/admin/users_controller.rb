class Admin::UsersController < AdminController
  rescue_from User::UnableToDestroyLastAdmin, with: :unable_to_destroy

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
      lost_admin = (@user.id == current_user.id && !@user.admin?)
      redirect_path = lost_admin ? root_path : admin_users_path
      redirect_to(redirect_path, notice: t(".update.success", user: @user.login_id))
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

    def unable_to_destroy(e = nil)
      logger.debug e.inspect if e
      flash[:warning] = t(".destroy.failed")
      redirect_to(admin_users_url)
    end
end
