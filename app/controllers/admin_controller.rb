class AdminController < ApplicationController
  skip_before_action :login_required
  before_action :require_admin

  rescue_from Exceptions::NonAdminUserAccess, with: :render_not_found

  def require_admin
    raise Exceptions::NonAdminUserAccess unless current_user&.admin?
  end

  def render_not_found(e = nil)
    logger.debug e.logger_message if e
    render(file: Rails.root.join("public/404.html"), status: 404, layout: false)
  end
end
