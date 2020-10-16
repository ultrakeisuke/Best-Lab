class Picture < ApplicationRecord
  MAX_PICTURES_COUNT = 5

  belongs_to :message
  mount_uploader :picture, PictureUploader
  validate :pictures_count_must_be_within_limit

  private
  
    def pictures_count_must_be_within_limit
      errors.add(:base, "画像の最大投稿数は#{MAX_PICTURES_COUNT}枚です") if message.pictures.count >= MAX_PICTURES_COUNT
    end

end
