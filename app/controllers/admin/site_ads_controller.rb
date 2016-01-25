class Admin::SiteAdsController < Admin::ApplicationController
  def index
    @site_ads = SiteAd.all
  end

  def new
    @site_ad = SiteAd.new
  end

  def create
   @site_ad = SiteAd.new(site_ad_params)
    if @site_ad.save
      redirect_to admin_site_ads_path
    else
      render action: :new
    end    
  end

  def edit
    @site_ad = SiteAd.find params[:id]
  end

  def update
    @site_ad = SiteAd.find params[:id]
    if @site_ad.update_attributes(site_ad_params)
      redirect_to admin_site_ads_path
    else
      render action: :edit
    end    
  end

  def destroy
    @site_ad = SiteAd.find params[:id]
    @site_ad.destroy
    redirect_to admin_site_ads_path    
  end

  private

  def site_ad_params
    params.require(:site_ad).permit(:key, :value, :title, :active, :sortrank)
  end
end