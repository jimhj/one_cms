class Site::TagsController < Site::ApplicationController
  def index
    @tags = Tag.order('id DESC')
  end

  def show
    @tag = Tag.find_by(slug: params[:id])
    @articles = @tag.articles.order('id DESC').paginate(page: params[:page], per_page: 20)
  end
end