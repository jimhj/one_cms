class Site::ArticlesController < Site::ApplicationController
  caches_action :feed, expires_in: 1.hour
  # caches_action :show

  def index
    @node = Node.find_by(slug: params[:slug])
    node_ids = @node.self_and_descendants.pluck(:id)
    @articles = Article.where(node_id: node_ids).order('id DESC').paginate(paginate_params)
    @links = @node.links
  end

  def show
    @article = Article.find params[:id]
  end

  def feed
    @articles = Article.includes(:article_body, :node).order('id DESC').limit(20)
    render layout: false
  end

  private

  def paginate_params
    { page: params[:page], per_page: 20 }
  end   
end
