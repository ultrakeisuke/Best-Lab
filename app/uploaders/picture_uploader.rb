class PictureUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick

  # 画像のリサイズ、表示形式の変更
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end
  
  # 上限変更
  process :resize_to_limit => [700, 700]
  
  # JPGで保存
  process :convert => 'jpg'
  
  # サムネイルを生成
  version :thumb do
    process resize_to_fill: [80, 80]
  end

  # jpg, jpeg, gif, pngのみ保存
  def extension_whitelist
    %w(jpg jpeg gif png)
  end

  # ファイル名を変更し拡張子を統一する
  def filename
    if original_filename.present?
      super.chomp(File.extname(super)) + '.jpg'
    end
  end

  # 日付で保存
  def filename
    time = Time.now
    name = time.strftime('%Y%m%d%H%M%S') + '.jpg'
    name.downcase
  end

end
