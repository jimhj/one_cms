module ApplicationHelper
  def article_path(article)
    "/#{article.node.slug}/#{article.id}"
  end

  def article_url(article)
    File.join(root_url, article_path(article)).to_s
  end

  def render_node_nav
     @nodes.first(7).collect do |child|
      "<a href='#{articles_path(child.slug)}' title='#{child.name}'>#{child.name}</a>"
    end.join('<span>-</span>').html_safe
  end

  def render_keyword_nav(channel)
     channel.keywords.first(8).collect do |keyword|
      "<a href='#{url_for}'>#{keyword}</a>"
    end.join('<span>-</span>').html_safe    
  end

  def channel_path(channel)
    "/z/#{channel.slug}/"
  end

  def article_format(html)
    # strs = [
    #   '#p#分页标题#e#',
    #   '.hzh {display: none; }',
    #   '养生吧（www.ys8.com）'
    # ]

    # # cleanup = html

    # cleanup = html.gsub(/<p>(<br>){0,}<\/p>/, '')
    #               .gsub(/(<br>){2,}(&nbsp;){0,}/, '<br>')

    # strs.each { |str| cleanup = cleanup.gsub(str, '') }
           
    # sanitize cleanup
    # sanitize html, tags: %w(table thead tbody tr th td p img br ol li a strong em span), attributes: %w(href class id target title alt)
    html.html_safe
  end

  def render_seo_meta_tags
    reverse = !(controller_name == 'application' && action_name == 'index')
    display_meta_tags site: SiteConfig.actived.site_name, 
                      title: SiteConfig.actived.site_title,
                      description: SiteConfig.actived.site_description,
                      keywords: SiteConfig.actived.site_keywords,
                      separator: '-',
                      reverse: reverse
  end
end
