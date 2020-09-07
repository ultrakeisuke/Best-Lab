class Picture < ApplicationRecord
  belongs_to :message
  mount_uploader :picture, PictureUploader
end
