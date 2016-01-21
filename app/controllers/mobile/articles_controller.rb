class Mobile::ArticlesController < Mobile::ApplicationController
  caches_action :index, :cache_path => Proc.new { |c| c.request.url + '-mobile' }, :expires_in => 1.hour
  caches_action :show, :cache_path => Proc.new{ |c| 'articles-' + c.params[:id] + '-mobile' }, :expires_in => 1.hour

  def index
    @node = Node.find_by(slug: params[:slug])
    @nodes = @node.self_and_descendants
    @articles = Article.where(node_id: @nodes.pluck(:id)).order('id DESC').paginate(page: params[:page], per_page: 20)
    @links = @node.links.mobile

    set_meta title: "#{@node.name}_#{@node.seo_title}",
             description: @node.seo_description,
             keywords: @node.seo_keywords    
  end

  def show
    @article = Article.find params[:id]
    @node = @article.node
    @nodes = @node.self_and_ancestors
    @more_articles = Article.includes(:node).where(node_id: @nodes.pluck(:id)).where.not(id: @article.id).limit(5)
    set_meta title: @article.title,
                  description: @article.seo_description,
                  keywords: @article.seo_keywords

    fresh_when(etag: @article, last_modified: @article.updated_at, public: true, template: false)
  end
end