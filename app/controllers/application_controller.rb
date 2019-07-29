class ApplicationController < ActionController::Base
  rescue_from StandardError, with: :render_500

  helper_method :current_user
  before_action :login_required

  private

    def current_user
      @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    end

    def login_required
      redirect_to(login_path) unless current_user
    end

    def render_404(e = nil)
      logger.error e.inspect if e
      render(file: Rails.root.join("public/404.html"), status: 404, layout: false)
    end

    def render_500(e = nil)
      logger.error e.full_message if e
      render(file: Rails.root.join("public/500.html"), status: 500, layout: false)
    end
end
