class Mobile::ArticlesController < Mobile::ApplicationController
  self.page_cache_directory = -> { Rails.root.join("public", 'mobile_cached_pages') }
  caches_page :index

  caches_action :index, :cache_path => Proc.new { |c| c.request.url + '-mobile' }, :expires_in => 6.hours
  caches_action :show, :cache_path => Proc.new{ |c| 'articles-' + "#{c.params[:slug]}-" + c.params[:id] + '-mobile' }, :expires_in => 6.hours

  def index
    @node = Node.find_by(slug: params[:slug])
    @nodes = @node.root.self_and_descendants
    @articles = Article.where(node_id: @nodes.pluck(:id)).order('id DESC').paginate(page: params[:page], per_page: 20)
    # @links = @node.links.mobile
    @miphtml = url_for(host: "#{Setting.mobile_domain}/mip", trailing_slash: true)

    set_meta title: "#{@node.name}_#{@node.seo_title}",
             description: @node.seo_description,
             keywords: @node.seo_keywords    
  end

  def show
    @article = Article.find params[:id]
    @node = Node.find_by!(slug: params[:slug])
    @nodes = @node.self_and_ancestors
    
    tag_ids = @article.taggings.pluck(:tag_id)
    if tag_ids.any?
      article_ids = Tagging.where(tag_id: tag_ids).order('id DESC').limit(8).pluck(:article_id)
      @more_articles = Article.where(id: article_ids).order('id DESC').limit(8).to_a

      if (ct = @more_articles.count) < 8
        more = Article.where(node_id: @nodes.pluck(:id)).limit(8 - ct).to_a
        @more_articles = @more_articles + more
      end
    else
      @more_articles = Article.where(node_id: @nodes.pluck(:id)).limit(8)
    end   
    
    set_meta_tags title: @article.format_seo_title,
                  description: @article.seo_description,
                  keywords: @article.seo_keywords

    # render layout: false, template: 'mobile/articles/wechat-show'

    render layout: false

    fresh_when(etag: [@article, Keyword.recent], template: false)    
  end
end