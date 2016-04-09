# encoding: utf-8

class FaviconUploader < CarrierWave::Uploader::Base

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  def default_url(*args)
    ActionController::Base.helpers.asset_path([version_name, "h4.ico"].compact.join('_'))
  end  

  def filename 
    if original_filename 
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end
end
