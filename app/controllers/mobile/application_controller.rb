class Mobile::ApplicationController < ApplicationController
  layout 'mobile'
  
  caches_action :index, expires_in: 1.hour, cache_path: 'mobile/index'

  def index
  end
end