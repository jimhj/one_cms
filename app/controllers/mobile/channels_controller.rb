class Mobile::ChannelsController < Mobile::ApplicationController
  def index
   @channels = Channel.order('sortrank DESC, id DESC').paginate(page: params[:page], per_page: 20)    
  end

  def show
    @channel = Channel.find_by slug: params[:slug]
    @articles = @channel.articles.order('id DESC').paginate(page: params[:page], per_page: 20)
  end
end