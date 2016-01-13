class Admin::SiteConfigController < Admin::ApplicationController
  def edit
    @configs = SiteConfig.all
  end

  def update
    confs = params.except(*request.path_parameters.keys).except(:utf8, :authenticity_token)
    confs.each_pair do |key, value|
      c = SiteConfig.find_by(key: key)
      next if c.nil?
      value.permit!
      c.update_attributes(value)
    end

    redirect_to :back
  end
end