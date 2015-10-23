class Admin::ApplicationController < ApplicationController
  layout 'admin'
  before_action :login_required
  before_action :require_admin

  private

  class AccessDenied < Exception; end

  def login_required
    unless login?
      flash[:warning] = '请先登录'
      redirect_to admin_login_path
    end
  end

  def current_user
    @current_user ||= login_from_session || login_from_cookies unless defined?(@current_user)
    @current_user
  end

  def require_admin
    unless current_user.admin?
      raise AccessDenied
    end
  end

  def login?
    !!current_user
  end

  def login_as(user)
    session[:user_id] = user.id
    @current_user = user
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
    forget_me
  end  

  def login_from_session
    if session[:user_id].present?
      begin
        User.find session[:user_id]
      rescue
        session[:user_id] = nil
      end
    end
  end  
end