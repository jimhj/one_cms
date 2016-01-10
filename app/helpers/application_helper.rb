module ApplicationHelper
  def article_path(article)
    "/#{article.node.slug}/#{article.id}"
  end

  def main_nav_class
    
  end
end
