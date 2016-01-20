class Mobile::ChannelsController < Mobile::ApplicationController
  def index
   @channels = Channel.order('sortrank DESC, id DESC').paginate(page: params[:page], per_page: 20)

   set_meta title: '热门专题'
  end

  def show
    @channel = Channel.find_by slug: params[:slug]
    @articles = @channel.articles.order('id DESC').paginate(page: params[:page], per_page: 20)

    seo_ary = [@channel.name, @channel.seo_keywords.presence || nil].compact
    set_meta title: seo_ary.join('_'),
             description: @channel.seo_description,
             keywords: seo_ary.join(',')    
  end
end