class Admin::SessionsController < Admin::ApplicationController
  layout false
  skip_before_action :login_required, only: [:new, :create]

  def new
  end

  def create
    admin = AdminUser.find_by(login: params[:login])
    if not verify_rucaptcha?
      flash[:warning] = '验证码不正确'
      redirect_to admin_login_path
    elsif admin && admin.authenticate(params[:password])
      login_as admin
      redirect_to admin_nodes_path
    else
      flash[:warning] = '账号或者密码不正确'
      redirect_to admin_login_path
    end
  end
end
