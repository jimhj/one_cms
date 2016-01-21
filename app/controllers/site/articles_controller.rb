class Site::ArticlesController < Site::ApplicationController
  caches_action :feed, expires_in: 1.hour
  caches_action :index, :cache_path => Proc.new { |c| c.request.url + '-desktop' }, :expires_in => 1.hour
  caches_action :show, :cache_path => Proc.new{ |c| 'articles-' + c.params[:id] + '-desktop' }, :expires_in => 1.hour  

  def index
    @node = Node.find_by(slug: params[:slug])
    @nodes = @node.self_and_descendants
    @articles = Article.where(node_id: @nodes.pluck(:id)).order('id DESC')
                       .paginate(page: params[:page], per_page: 20, total_entries: 1000000)
    @links = @node.links.pc

    title = [@node.name, @node.seo_title.presence || nil].compact.join('_')
    set_meta title: title,
             description: @node.seo_description,
             keywords: @node.seo_keywords
  end

  def show
    @article = Article.find params[:id]
    @node = @article.node
    @nodes = @node.self_and_ancestors
    @more_articles = Article.includes(:node).where(node_id: @nodes.pluck(:id)).where.not(id: @article.id).limit(8)

    set_meta title: @article.title,
                  description: @article.seo_description,
                  keywords: @article.seo_keywords

    fresh_when(etag: @article, last_modified: @article.updated_at, public: true, template: false) 
  end

  def feed
    @articles = Article.includes(:article_body, :node).order('id DESC').limit(20)
    render layout: false
  end   
end
