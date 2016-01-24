class Admin::NodesController < Admin::ApplicationController
  def index
    @nodes = Node.roots
  end

  def new
    @node = Node.new(parent_id: params[:parent_id])
  end

  def create
    @node = Node.new(node_params)
    if @node.save
      redirect_to admin_nodes_path
    else
      render action: :new
    end
  end

  def edit
    @node = Node.find params[:id]
  end

  def update
    @node = Node.find params[:id]
    if @node.update_attributes(node_params)
      redirect_to admin_nodes_path
    else
      render action: :edit
    end
  end

  private

  def node_params
    params.require(:node).permit(:name, :parent_id, :slug, :seo_title, :seo_keywords, :seo_description)
  end
end
