class Mobile::ApplicationController < ApplicationController
  layout 'mobile'

  # self.page_cache_directory = Rails.root.join('public/page_cache/mobile').to_s

  caches_action :index, :cache_path => Proc.new { |c| c.request.url + '-mobile-index' }, :expires_in => 2.hours

  # caches_page :index, if: Proc.new {
  #   controller_name == 'application'
  # }

  def index
    @articles = Article.recommend(page: params[:page])
    @links = Link.where(linkable_id: 0).mobile
  end
end