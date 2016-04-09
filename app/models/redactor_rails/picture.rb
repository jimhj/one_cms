class RedactorRails::Picture < RedactorRails::Asset
  mount_uploader :data, RedactorRailsPictureUploader, :mount_on => :data_file_name

  def url_content
    url(:content)
  end

  def qn_url(version)
    return url if not Setting.qiniu.active

    image_path = url.split(Setting.carrierwave.asset_host + '/').last
    host = if Setting.qiniu.mirror_on
      Setting.qiniu.mirror_host
    else
      Setting.qiniu.host
    end
    "#{File.join(host, image_path).to_s}!#{version}"
  end
end
