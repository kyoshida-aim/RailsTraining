class AdminController < ApplicationController
  skip_before_action :login_required
  before_action :require_admin

  rescue_from Exceptions::NonAdminUserAccess, with: :render_404

  def require_admin
    raise Exceptions::NonAdminUserAccess unless current_user&.admin?
  end
end
