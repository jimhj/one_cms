class Mobile::ArticlesController < Mobile::ApplicationController
  def index
  end

  def show
    @article = Article.all.sample
  end
end