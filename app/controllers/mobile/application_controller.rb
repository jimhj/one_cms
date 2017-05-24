class Mobile::ApplicationController < ApplicationController
  layout 'tt_mobile'
  
  # layout 'mobile'

  # self.page_cache_directory = Rails.root.join('public/page_cache/mobile').to_s

  # caches_action :index, :cache_path => Proc.new { |c| c.request.url + '-mobile-index' }, :expires_in => 2.hours

  # caches_action :index, cache_path: Proc.new { |c| 
  #   c.request.url + '-mobile-index' 
  # }, if: Proc.new {
  #   controller_name == 'application'
  # }, :expires_in => 2.hours

  self.page_cache_directory = -> { Rails.root.join("public", 'mobile_cached_pages') }
  caches_page :index

  def index
    @articles = Article.recommend(page: params[:page])
    @miphtml = "#{Setting.mobile_domain}/mip/"
    # @links = Link.where(linkable_id: 0).mobile
  end
end