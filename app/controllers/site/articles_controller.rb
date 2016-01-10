class Site::ArticlesController < Site::ApplicationController
  def index
    @node = Node.find_by(slug: params[:slug])
    node_ids = @node.self_and_descendants.pluck(:id)
    @articles = Article.where(node_id: node_ids).order('id DESC').paginate(paginate_params)
  end

  def show
    @article = Article.find params[:id]
  end

  private

  def paginate_params
    { page: params[:page], per_page: 40 }
  end   
end
