class AdminController < ApplicationController
  class NonAdminUserAccess < StandardError; end

  skip_before_action :login_required
  before_action :require_admin

  rescue_from NonAdminUserAccess, with: :render_404

  def require_admin
    raise(NonAdminUserAccess, "Access attempt from non-admin user detected") unless current_user&.admin?
  end
end
