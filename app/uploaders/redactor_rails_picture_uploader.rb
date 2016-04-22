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

    if Setting.mem_space == 'h4'
      if model.id <= 64008
        "system/redactor_assets/pictures/#{model.id}"
      elsif model.id > 64008 && model.id <= 128381
        "system/redactor_assets/pictures_2/#{model.id}"
      else
        "system/redactor_assets/pictures_3/#{id_partition}/#{model.id}"
      end
    elsif Setting.mem_space == 'msj'
      if model.id <= 31598
       "system/redactor_assets/pictures/#{model.id}"
      else
        "system/redactor_assets/pictures_3/#{id_partition}/#{model.id}"
      end
    else
      "system/redactor_assets/pictures_3/#{id_partition}/#{model.id}"
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
    # RedactorRails.image_file_types
    nil
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    # p file.content_type.split('image/')
    @name ||= Digest::MD5.hexdigest(current_path)
    "#{Time.now.year}/#{@name}.#{file.content_type.split('image/').last.downcase}"
  end

  def id_partition
    ("%09d" % model.id).scan(/\d{3}/).join("/")
  end
end
