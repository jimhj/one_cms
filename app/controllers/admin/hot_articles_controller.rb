class Admin::HotArticlesController < Admin::ApplicationController
  def index
    @hot_articles = HotArticle.order('sortrank DESC, id DESC')
  end

  def new
    @hot_article = HotArticle.new
  end

  def create
   @hot_article = HotArticle.new(hot_params)
    if @hot_article.save
      redirect_to admin_hot_articles_path
    else
      render action: :new
    end    
  end

  def edit
    @hot_article = HotArticle.find params[:id]
  end

  def update
    @hot_article = HotArticle.find params[:id]
    if @hot_article.update_attributes(hot_params)
      redirect_to admin_hot_articles_path
    else
      render action: :edit
    end    
  end

  def destroy
    @hot_article = HotArticle.find params[:id]
    @hot_article.destroy
    redirect_to admin_hot_articles_path    
  end

  private

  def hot_params
    params.require(:hot_article).permit(:title, :link, :sortrank, :active)
  end
end