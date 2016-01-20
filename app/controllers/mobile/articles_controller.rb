class Mobile::ArticlesController < Mobile::ApplicationController
  def index
  end

  def show
    @article = Article.find params[:id]
  end
end