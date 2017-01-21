class Mobile::MipController < Mobile::ApplicationController
  caches_action :show, :cache_path => Proc.new{ |c| 'mip-' + "#{c.params[:slug]}-" + c.params[:id] }, :expires_in => 6.hours

  def show
    @article = Article.find params[:id]
    @node = Node.find_by!(slug: params[:slug])

    @nodes = @node.self_and_ancestors
    @more_articles = Article.where(node_id: @nodes.pluck(:id)).limit(8)    
    
    set_meta_tags title: @article.format_seo_title,
                  description: @article.seo_description,
                  keywords: @article.seo_keywords

    render layout: false

    fresh_when(etag: [@article, Keyword.recent], template: false) 
  end
end