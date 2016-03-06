class Admin::NodesController < Admin::ApplicationController
  def index
    @nodes = Node.roots
  end

  def list
    @nodes = Node.order('id ASC')
  end

  def new
    @node = Node.new(parent_id: params[:parent_id])
  end

  def create
    if @node = Node.find_by(slug: node_params[:slug])
      if @node.update_attributes(node_params)
        redirect_to admin_nodes_path
      else
        render action: :new
      end
    else
      @node = Node.new(node_params)
      if @node.save
        redirect_to admin_nodes_path
      else
        render action: :new
      end      
    end
  end

  def edit
    @node = Node.find params[:id]
  end

  def update
    @node = Node.find params[:id]
    # if node_params[:parent_id] == 0
    # else
    # end
    if @node.update_attributes(node_params)
      redirect_to admin_nodes_path
    else
      render action: :edit
    end
  end

  def destroy
    @node = Node.find params[:id]
    ActiveRecord::Base.transaction do
      @node.destroy
    end

    redirect_to admin_nodes_path
  end

  private

  def node_params
    params.require(:node).permit(:name, :parent_id, :slug, :seo_title, :seo_keywords, :seo_description)
  end
end
