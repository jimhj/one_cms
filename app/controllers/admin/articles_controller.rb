class Admin::ArticlesController < Admin::ApplicationController
  def index
    @articles = Article.joins(:article_body, :node).order('created_at DESC')
  end

  def new
    @article = Article.new
    @article.build_article_body
  end

  def create
    @article = Article.new(article_params)
    if @article.save
      redirect_to admin_articles_path
    else
      render action: :new
    end
  end

  def edit
    @article = Article.find params[:id]
  end

  def update
    @article = Article.find params[:id]
    if @article.update_attributes(article_params)
      redirect_to admin_articles_path
    else
      render action: :edit
    end
  end

  def show
    @article = Article.find params[:id]
  end

  def destroy
    @article = Article.find params[:id]
    @article.destroy

    redirect_to admin_articles_path
  end

  private

  def article_params
    params.require(:article).permit(:node_id, :title, :short_title, :thumb, :source, :seo_title, :seo_keywords, :seo_description, :hot, :focus, :article_body_attributes => [:id, :body])
  end
end
