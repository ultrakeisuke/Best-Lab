class MessageForm
  # ActionPackやActionViewと連携。validationを使えるようにする
  include ActiveModel::Model
  # オブジェクト生成の際にパラメータに指定する属性(attribute)を定義できるようにする
  include Virtus.model
  # Model以外でCarrierWaveを使えるようにする
  extend CarrierWave::Mount

  validates :body, length: { maximum: 10000 }
  validates :body_or_pictures, presence: true

  attribute :user_id, Integer
  attribute :room_id, Integer
  attribute :body, String
  attribute :picture, String

  mount_uploader :picture, PictureUploader

  private

    # メッセージに文章か画像が含まれるよう制限する
    def body_or_pictures
      body.presence or picture.presence
    end

end
