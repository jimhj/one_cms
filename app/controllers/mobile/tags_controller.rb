class Mobile::TagsController < Mobile::ApplicationController
  def index
  end

  def show
    @articles = Article.order('id DESC').paginate(page: params[:page], per_page: 20)
  end
end