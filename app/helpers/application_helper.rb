module ApplicationHelper
  def article_path(article)
    "/#{article.node.slug}/#{article.id}"
  end

  def article_url(article)
    File.join(root_url, article_path(article)).to_s
  end

  def render_node_nav(node)
     node.children.first(8).collect do |child|
      "<a href='#{articles_path(child.slug)}' title='#{child.name}'>#{child.name}</a>"
    end.join('<span>-</span>').html_safe
  end

  def render_keyword_nav(channel)
     channel.keywords.first(8).collect do |keyword|
      "<a href='#{url_for}'>#{keyword}</a>"
    end.join('<span>-</span>').html_safe    
  end

  def channel_path(channel)
    "/z/#{channel.slug}"
  end

  def article_format(html)
    cleanup = html.gsub(/<p>(<br>){0,}<\/p>/, '')
                  .gsub(/(<br>){2,}/, '<br>')
           
    sanitize cleanup
  end
end
