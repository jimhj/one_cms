class Site::ApplicationController < ApplicationController
  layout 'site'

  # self.page_cache_directory = Rails.root.join('public/page_cache/desktop').to_s

  caches_action :index, cache_path: 'desktop/index', if: Proc.new {
    controller_name == 'application'
  }, :expires_in => 2.hours

  # caches_page :index, if: Proc.new {
  #   controller_name == 'application'
  # }

  def index
    @links = Link.where(linkable_id: 0).pc
    @focus = Article.focus
    @topnews = Article.hot
    @articles = Article.recommend
  end

  def more
    @articles = Article.recommend(page: params[:page], load: 5)
    html = render_to_string(partial: 'site/application/index_article', layout: false, collection: @articles, as: :article, locals: { lazyload: true, page: params[:page] })
    render json: { html: html }
  end
end
