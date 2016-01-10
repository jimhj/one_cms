module ApplicationHelper
  def article_path(article)
    "/#{article.node.slug}/#{article.id}"
  end
end
