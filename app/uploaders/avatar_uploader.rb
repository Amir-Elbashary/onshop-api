class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  # process crop: :avatar

  storage :file
  # storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*args)
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  
  # Create different versions of your uploaded files:
  version :thumb do            
    process resize_to_fit: [50, 50] 
  end                          

  version :small_200 do            
    process resize_to_fit: [200, 200]
  end

  version :small_400 do            
    process resize_to_fit: [400, 400]
  end
  
  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_whitelist
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
end
