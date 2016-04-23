class Admin::ArticlesController < Admin::ApplicationController
  def index
    if params[:node_id].blank?
      @articles = Article.joins(:node).paginate(paginate_params).order('created_at DESC')
    else
      @node = Node.find params[:node_id]
      node_ids = @node.self_and_descendants.pluck(:id)
      @articles = Article.where(node_id: node_ids).joins(:node).paginate(paginate_params).order('created_at DESC')
    end
  end

  def search
    @articles = Article.where("title LIKE '%#{params[:q]}%'").paginate(paginate_params).order('created_at DESC')
    render :index
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
      redirect_to admin_articles_path(page: params[:page], node_id: params[:node_id])
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
    params.require(:article).permit(:node_id, :title, :short_title, :thumb, :source, :writer, :seo_title, :seo_keywords, :seo_description, :hot, :focus, :recommend, :linked, :link_word, :article_body_attributes => [:id, :body])
  end

  def paginate_params
    { page: params[:page], per_page: 40, total_entries: 1000000 }
  end  
end
