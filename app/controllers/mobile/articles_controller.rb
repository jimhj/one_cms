class Mobile::ArticlesController < Mobile::ApplicationController
  caches_action :index, :cache_path => Proc.new { |c| c.request.url + '-mobile' }, :expires_in => 6.hours
  caches_action :show, :cache_path => Proc.new{ |c| 'articles-' + "#{c.params[:slug]}-" + c.params[:id] + '-mobile' }, :expires_in => 6.hours

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

    @nodes = Node.all.pluck(:id).sample(20)
    @more_articles = Article.where('pictures_count > 0').order('id DESC').limit(5)
    
    set_meta_tags title: @article.format_seo_title,
                  description: @article.seo_description,
                  keywords: @article.seo_keywords

    render layout: false, template: 'mobile/articles/wechat-show'

    fresh_when(etag: [@article, Keyword.recent], template: false)    
  end
end