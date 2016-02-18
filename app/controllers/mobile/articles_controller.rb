class Mobile::ArticlesController < Mobile::ApplicationController
  caches_action :index, :cache_path => Proc.new { |c| c.request.url + '-mobile' }, :expires_in => 6.hours
  caches_action :show, :cache_path => Proc.new{ |c| 'articles-' + " #{c.params[:slug]} -" + c.params[:id] + '-mobile' }, :expires_in => 30.minutes

  def index
    @node = Node.find_by(slug: params[:slug])
    @nodes = @node.root.self_and_descendants
    @articles = Article.where(node_id: @nodes.pluck(:id)).order('id DESC').paginate(page: params[:page], per_page: 20)
    @links = @node.links.mobile

    set_meta title: "#{@node.name}_#{@node.seo_title}",
             description: @node.seo_description,
             keywords: @node.seo_keywords    
  end

  def show
    @article = Article.find params[:id]
    @node = Node.find_by!(slug: params[:slug])
    @nodes = @node.root.self_and_ancestors
    @more_articles = Article.where(node_id: @nodes.pluck(:id)).where.not(id: @article.id).limit(5)
    set_meta_tags title: @article.title,
                  description: @article.seo_description,
                  keywords: @article.seo_keywords

    fresh_when(etag: [@article, Keyword.recent], template: false) 
  end
end