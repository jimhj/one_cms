# encoding: utf-8

class ThumbUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  version :large do
    process resize_to_limit: [620, 390]
  end

  version :square do
    process resize_to_fill: [300, 300]
  end

  version :middle, from_version: :square do
    process resize_to_limit: [200, 150]
  end  

  version :small do
    process resize_to_limit: [90, 60]
  end

  def default_url(*args)
    ActionController::Base.helpers.asset_path("site/" + [version_name, "thumb.png"].compact.join('_'))
  end  

  def store_dir
    # "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    if model.id <= 821431
      "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}_2/#{id_partition}/#{model.id}"
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png ico)
  end

  def filename 
    if original_filename 
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end

  def id_partition
    ("%09d" % model.id).scan(/\d{3}/).join("/")
  end
end
