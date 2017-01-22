class Mobile::MipController < Mobile::ApplicationController
  layout false

  caches_action :show, :cache_path => Proc.new{ |c| c.request.url }, :expires_in => 6.hours
  caches_action :index, :cache_path => Proc.new { |c| c.request.url }, :expires_in => 6.hours
  caches_action :node, :cache_path => Proc.new { |c| c.request.url }, :expires_in => 6.hours

  def show
    @article = Article.find params[:id]
    @node = Node.find_by!(slug: params[:slug])

    @nodes = @node.self_and_ancestors
    @more_articles = Article.where(node_id: @nodes.pluck(:id)).limit(8)    
    
    set_meta_tags title: @article.format_seo_title,
                  description: @article.seo_description,
                  keywords: @article.seo_keywords

    fresh_when(etag: [@article, Keyword.recent], template: false) 
  end

  def node
    @node = Node.find_by(slug: params[:slug])
    @nodes = @node.root.self_and_descendants
    @articles = Article.where(node_id: @nodes.pluck(:id)).order('id DESC').paginate(page: params[:page], per_page: 20)
    @links = @node.links.mobile

    set_meta title: "#{@node.name}_#{@node.seo_title}",
             description: @node.seo_description,
             keywords: @node.seo_keywords  
  end

  def index
    @articles = Article.recommend(page: params[:page])
  end
end