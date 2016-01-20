class Mobile::ArticlesController < Mobile::ApplicationController
  def index
    @node = Node.find_by(slug: params[:slug])
    node_ids = @node.self_and_descendants.pluck(:id)
    @articles = Article.where(node_id: node_ids).order('id DESC').paginate(page: params[:page], per_page: 20)
  end

  def show
    @article = Article.find params[:id]
  end
end