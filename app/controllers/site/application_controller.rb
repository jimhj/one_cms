class Site::ApplicationController < ApplicationController
  layout 'site'

  caches_action :index, expires_in: 1.hour

  def index
    @links = Link.where(linkable_id: 0)
  end
end
