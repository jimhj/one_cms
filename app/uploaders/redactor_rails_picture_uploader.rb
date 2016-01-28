# encoding: utf-8
class RedactorRailsPictureUploader < CarrierWave::Uploader::Base
  include RedactorRails::Backend::CarrierWave

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  storage :file

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    # "system/redactor_assets/pictures/#{model.id}"
    if model.id <= 64008
      "system/redactor_assets/pictures/#{model.id}"
    else
      "system/redactor_assets/pictures_2/#{model.created_at.strftime('%Y%m')}/#{model.id}"
    end
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  process :read_dimensions

  # Create different versions of your uploaded files:
  version :thumb do
    process :resize_to_fill => [118, 100]
  end

  version :content do
    process :resize_to_limit => [800, 800]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    RedactorRails.image_file_types
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    if super.present?
      @name ||= Digest::MD5.hexdigest(current_path)
      "#{Time.now.year}/#{@name}.#{file.extension.downcase}"
    end
  end
end
