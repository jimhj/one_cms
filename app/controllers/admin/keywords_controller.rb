class Admin::KeywordsController < Admin::ApplicationController
  def index
    @keywords = Keyword.order('sortrank DESC, created_at DESC').paginate(per_page: 50, page: params[:page], total_entries: 20000)
  end

  def new
    @keyword = Keyword.new
  end

  def create
    @keyword = Keyword.new(keyword_params)
    if @keyword.save
      redirect_to admin_keywords_path
    else
      render action: :new
    end
  end

  def edit
    @keyword = Keyword.find(params[:id])
  end

  def update
    @keyword = Keyword.find(params[:id])
    if @keyword.update_attributes(keyword_params)
      redirect_to admin_keywords_path
    else
      render action: :edit
    end
  end

  def destroy
    @keyword = Keyword.find(params[:id])
    @keyword.destroy
    redirect_to admin_keywords_path, notice: '已删除'
  end

  private

  def keyword_params
    params.require(:keyword).permit(:name, :url, :sortrank)
  end
end
