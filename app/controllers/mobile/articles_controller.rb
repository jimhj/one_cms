class Mobile::ArticlesController < Mobile::ApplicationController
  def index
    @node = Node.find_by(slug: params[:slug])
    node_ids = @node.self_and_descendants.pluck(:id)
    @articles = Article.where(node_id: node_ids).order('id DESC').paginate(page: params[:page], per_page: 20)

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
end