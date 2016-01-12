module ApplicationHelper
  def article_path(article)
    "/#{article.node.slug}/#{article.id}"
  end

  def article_url(article)
    File.join(root_url, article_path(article)).to_s
  end

  def render_right_nav(node)
     node.children.first(8).collect do |child|
      "<a href='#{articles_path(child.slug)}' title='#{child.name}'>#{child.name}</a>"
    end.join('<span>-</span>').html_safe
  end

  def channel_path(channel)
    "/z/#{channel.slug}"
  end
end
