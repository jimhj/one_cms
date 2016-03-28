class Site::ApplicationController < ApplicationController
  layout 'site'

  caches_action :index, cache_path: 'desktop/index', if: Proc.new {
    controller_name == 'application'
  }, :expires_in => 2.hours

  def index
    @links = Link.where(linkable_id: 0).pc
    @focus = Article.focus
    @topnews = Article.topnews
    @articles = Article.recommend(page: params[:page], load: 20)

    respond_to do |req|
      req.html
      req.js {
        html = render_to_string(partial: 'site/application/index_articles', layout: false, locals: { articles: @articles })
        render json: { html: html }
      }
    end
  end
end
