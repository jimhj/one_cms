class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def set_meta(tags)
    tags = tags.delete_if { |name, value| value.blank? }
    set_meta_tags tags
  end
end
