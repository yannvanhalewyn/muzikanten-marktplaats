class Image < ActiveRecord::Base
  belongs_to :advert
  mount_uploader :asset, AssetUploader
  validates_presence_of :asset
end
