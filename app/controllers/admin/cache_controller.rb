class Admin::CacheController < Admin::ApplicationController
  def recache_index
    cache_views = ['desktop/index', 'mobile/index']
    cache_views.each do |view|
      expire_fragement(view)
      curl " 127.0.0.1:7654", view.include?('mobile')
    end
  end

  def cache_tag
  end

  def cache_channel
  end

  def cache_article_list
    
  end

  private

  def curl(localurl, mobile = false)
    cmd = "curl #{localurl}"
    if mobile
      cmd << ' -A User-agent: Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en) AppleWebKit/420.1 (KHTML, like Gecko) Version/3.0 Mobile/3B48b Safari/419.3'
    end

    system cmd
  end
end