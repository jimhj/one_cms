module ApplicationHelper
  def article_path(article)
    "/#{article.node.slug}/#{article.id}"
  end

  def render_right_nav(node)
     node.children.first(8).collect do |child|
      "<a href='#{articles_path(child.slug)}' title='#{child.name}'>#{child.name}</a>"
    end.join('<span>-</span>').html_safe
  end
end
