class Mobile::ApplicationController < ApplicationController
  layout 'mobile'
  
  caches_action :index, cache_path: 'mobile/index', expires_in: 2.hours, if: Proc.new {
    controller_name == 'application'
  }

  def index
    @links = Link.where(linkable_id: 0).mobile
  end
end