class RedactorRails::Picture < RedactorRails::Asset
  mount_uploader :data, RedactorRailsPictureUploader, :mount_on => :data_file_name

  def url_content
    url(:content)
  end

  # after_create do
  #   if assetable.present?
  #     assetable.increment :pictures_count
  #   end
  # end
end
