class Site::ApplicationController < ApplicationController
  layout 'site'

  caches_action :index

  def index
    @links = Link.where(linkable_id: 0)
  end
end
