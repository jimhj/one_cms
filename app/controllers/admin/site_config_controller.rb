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

  def mip
    record_store_path = Rails.root.join('public', 'baidu_mip_record.txt')
    @last_record_id, @submit_number, @total, @remain, @error = File.read(record_store_path).split(/\n/)
    @last_record_id ||= 769
    @submit_number ||= 0
    @total ||= { "remain" => '', "success" => '' }
    @remain ||= 0
    @error ||= ""
  end

  private

  def config_params
    params.require(:site_config).permit!
  end
end