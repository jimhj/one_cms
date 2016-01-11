class Admin::LinksController < Admin::ApplicationController
  before_action :find_link, only: [:edit, :update, :destroy]

  def index
   @links = Link.order('sortrank DESC, id DESC') 
  end

  def new
    @link = Link.new
    @link.linkable_type = 'Node'
  end

  def create
    @link = Link.new(link_params)
    if @link.save
      redirect_to admin_links_path
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @link.update_attributes(link_params)
      redirect_to admin_links_path
    else
      render action: :edit
    end
  end

  def destroy
    @link.destroy
    redirect_to admin_links_path
  end  

  private

  def find_link
    @link = Link.find params[:id]
  end

  def link_params
    params.require(:link).permit(:name, :url, :title, :qq, :sortrank, :linkable_type, :linkable_id)
  end
end