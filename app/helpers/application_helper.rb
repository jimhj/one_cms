module ApplicationHelper
  def article_path(article)
    path = articles_path(article.node)
    "#{path}/#{article.id}"
  end

  def articles_path(node)
    dirs = node.self_and_ancestors.pluck(:slug)
    path = dirs.join('/')
    "/#{path}"    
  end
end
