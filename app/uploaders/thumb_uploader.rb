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

  version :small do
    process resize_to_limit: [90, 60]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename 
    if original_filename 
      @name ||= Digest::MD5.hexdigest(File.dirname(current_path))
      "#{@name}.#{file.extension}"
    end
  end
end
