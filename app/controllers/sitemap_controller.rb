class SitemapController < ApplicationController
  caches_action :show, expires_in: 2.hours

  def show
    @node = Node.find params[:node_id]
    node_ids = @node.self_and_descendants.pluck(:id)
    @host = Rails.env.development? ? 'http://127.0.0.1:8000': "http://#{SiteConfig.actived.domain}"
    @articles = Article.where(node_id: node_ids).order('id DESC').paginate(per_page: 10000, total_entries: 1000000, page: params[:page]) 
  end
end