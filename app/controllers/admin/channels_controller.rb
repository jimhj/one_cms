class Admin::ChannelsController < Admin::ApplicationController
  def index
    @channels = Channel.order('sortrank DESC, created_at DESC').paginate(paginate_params)
  end

  def new
    @channel = Channel.new
  end

  def create
    @channel = Channel.new(channel_params)
    if @channel.save
      redirect_to admin_channels_path
    else
      render action: :new
    end
  end

  def edit
    @channel = Channel.find(params[:id])
  end

  def update
    @channel = Channel.find(params[:id])
    if @channel.update_attributes(channel_params)
      redirect_to admin_channels_path
    else
      render action: :edit
    end
  end

  def destroy
    @channel = Channel.find(params[:id])
    @channel.destroy
    redirect_to admin_channels_path, notice: '已删除'
  end

  private

  def channel_params
    params.require(:channel).permit(:name, :slug, :seo_keywords, :seo_description, :sortrank)
  end

  def paginate_params
    { page: params[:page], per_page: 40 }
  end 
end
