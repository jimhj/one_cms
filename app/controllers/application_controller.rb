class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # before_action :prepare_for_mobile

  # private

  # def mobile_device?
  #   request.user_agent =~ /Mobile|webOS/ or request.subdomain == 'm'
  # end

  # helper_method :mobile_device?

  # def prepare_for_mobile
  #   if mobile_device?
  #     request.format = :mobile 
  #   end
  # end

  private

  def set_meta(tags)
    tags = tags.delete_if { |name, value| value.blank? }
    set_meta_tags tags
  end
end
