class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  mount_uploader :picture, PictureUploader
end
