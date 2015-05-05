require "carrierwave/orm/activerecord"

if Rails.env.test? || Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end

  # make sure our uploader is auto-loaded
  AssetUploader

  # use different dirs when testing
  CarrierWave::Uploader::Base.descendants.each do |klass|
    next if klass.anonymous?
    klass.class_eval do

      storage = :file

      def cache_dir
        "#{Rails.root}/public/spec/uploads/tmp"
      end

      def store_dir
        "#{Rails.root}/public/spec/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
      end
    end
  end
end
