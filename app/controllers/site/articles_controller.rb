class Site::ArticlesController < Site::ApplicationController
  caches_action :feed, expires_in: 1.hour
  # caches_action :show

  def index
    @node = Node.find_by(slug: params[:slug])
    node_ids = @node.self_and_descendants.pluck(:id)
    @articles = Article.where(node_id: node_ids).order('id DESC').paginate(paginate_params)
    @links = @node.links

    set_meta title: "#{@node.name}_#{@node.seo_title}",
             description: @node.seo_description,
             keywords: @node.seo_keywords
  end

  def show
    @article = Article.find params[:id]

    set_meta title: @article.title,
                  description: @article.seo_description,
                  keywords: @article.seo_keywords       
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
