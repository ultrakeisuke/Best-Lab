class Picture < ApplicationRecord
  MAX_PICTURES_COUNT = 5

  belongs_to :message
  mount_uploader :picture, PictureUploader
  validate :pictures_count_must_be_within_limit

  private
    def pictures_count_must_be_within_limit
      if message && message.pictures.length > MAX_PICTURES_COUNT
        errors.add(:base, "投稿できる画像は#{MAX_PICTURES_COUNT}枚までです。")
      end
    end

end
