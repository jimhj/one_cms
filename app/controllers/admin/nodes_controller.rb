class Admin::NodesController < Admin::ApplicationController
  def index
    @nodes = Node.order('sortrank DESC, created_at DESC')
  end

  def new
    @node = Node.new
    @parent_node = Node.find_by(id: params[:parent_id])
    if @parent_node.present?
      @node = @parent_node.child_nodes.build
    else
      @node = Node.new
    end
  end

  def create
    @node = Node.new(node_params)
    if @node.save
      redirect_to admin_nodes_path
    else
      render action: :new
    end
  end

  private

  def node_params
    params.require(:node).permit(:name, :parent_id, :slug, :seo_title, :seo_keywords, :seo_description)
  end
end
