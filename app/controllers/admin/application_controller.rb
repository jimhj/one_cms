class Admin::ApplicationController < ApplicationController
  layout 'admin'
  before_action :login_required

  private

  class AccessDenied < Exception; end

  def login_required
    unless login?
      flash[:warning] = '请先登录'
      redirect_to admin_login_path
    end
  end

  def current_admin
    @current_admin ||= login_from_session unless defined?(@current_admin)
    @current_admin
  end

  def login?
    !!current_admin
  end

  def login_as(admin)
    session[:admin_id] = admin.id
    @current_admin = admin
  end

  def logout
    session.delete(:admin_id)
    @current_admin = nil
  end

  def login_from_session
    if session[:admin_id].present?
      begin
        AdminUser.find session[:admin_id]
      rescue
        session[:admin_id] = nil
      end
    end
  end
end
