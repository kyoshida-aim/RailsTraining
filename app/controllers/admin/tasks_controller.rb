class Admin::TasksController < AdminController
  def index
    @user = User.find(params[:user_id])
    # ransackにより受け渡されるパラメータ:qによってソート
    @q = @user.tasks.order(created_at: :desc).ransack(params[:q])
    @tasks = @q.result.page(params[:page])
  end

  def show
    @user = User.find(params[:user_id])
    @task = @user.tasks.find(params[:id])
  end
end
