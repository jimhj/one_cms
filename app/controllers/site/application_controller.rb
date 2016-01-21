class Site::ApplicationController < ApplicationController
  layout 'site'

  caches_action :index, expires_in: 1.hour, cache_path: 'desktop/index', if: Proc.new {
    controller_name == 'application'
  }

  def index
    @links = Link.where(linkable_id: 0).pc
    @focus = Article.focus
    @topnews = Article.topnews
  end
end
