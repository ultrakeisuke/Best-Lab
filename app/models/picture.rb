class Picture < ApplicationRecord
  MAX_PICTURES_COUNT = 4

  belongs_to :message, optional: true
  belongs_to :post, optional: true
  mount_uploader :picture, PictureUploader
  validate :pictures_count_must_be_within_limit

  private
    # メッセージに紐づく画像の枚数を制限する
    def pictures_count_must_be_within_limit
      if message && message.pictures.length > MAX_PICTURES_COUNT
        errors.add(:base, "投稿できる画像は#{MAX_PICTURES_COUNT}枚までです。")
      end
    end

end
