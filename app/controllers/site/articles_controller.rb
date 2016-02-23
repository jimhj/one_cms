class Site::ArticlesController < Site::ApplicationController
  caches_action :feed, expires_in: 2.hours
  caches_action :index, :cache_path => Proc.new { |c| c.request.url + '-desktop' }, :expires_in => 6.hours
  caches_action :show, :cache_path => Proc.new{ |c| 'articles' + "-#{c.params[:slug]}-" + c.params[:id] + '-desktop' }, :expires_in => 1.hour

  def index
    @node = Node.find_by!(slug: params[:slug])
    @nodes = @node.root.self_and_descendants
    @articles = Article.where(node_id: @node.self_and_descendants.pluck(:id)).order('id DESC')
                       .paginate(page: params[:page], per_page: 20, total_entries: 1000000)
    @links = @node.links.pc
    @channel_keywords = @node.seo_keywords

    title = [@node.name, @node.seo_title.presence || nil].compact.join('_')
    set_meta title: title,
             description: @node.seo_description,
             keywords: @node.seo_keywords
  end

  def show
    @node = Node.find_by!(slug: params[:slug])
    @article = @node.articles.find(params[:id])

    if @article.pictures_count < 0
      @article.set_pictures_count
    end
    
    @nodes = @node.self_and_ancestors
    @more_articles = Article.where(node_id: @nodes.pluck(:id)).where.not(id: @article.id).limit(8)
    @channel_keywords = @article.seo_keywords
    
    set_meta_tags title: @article.title,
                  description: @article.seo_description,
                  keywords: @article.seo_keywords

    fresh_when(etag: [@article, Keyword.recent], template: false) 
  end

  def search
    url = "http://s.h4.com.cn/cse/search?q=#{CGI::escape(params[:q])}&click=1&s=14346881451190138661&nsid=1"
    redirect_to url
  end

  def feed
    @articles = Article.includes(:article_body, :node).order('id DESC').limit(200)
    render layout: false
  end   
end
