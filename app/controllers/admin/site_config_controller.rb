class Admin::SiteConfigController < Admin::ApplicationController
  def edit
    @config = SiteConfig.first
  end

  def update
    @config = SiteConfig.first
    if @config.update_attributes config_params
      redirect_to admin_site_config_path
    else
      render :edit
    end
  end

  private

  def config_params
    params.require(:site_config).permit!
  end
end