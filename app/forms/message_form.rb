class MessageForm
  MAX_PICTURES_COUNT = 4

  # ActionPackやActionViewと連携。validationを使えるようにする
  include ActiveModel::Model
  # オブジェクト生成の際にパラメータに指定する属性(attribute)を定義できるようにする
  include Virtus.model
  # Model以外でCarrierWaveを使えるようにする
  extend CarrierWave::Mount

  validates :body, length: { maximum: 10_000 }
  validate :body_or_pictures
  validate :max_num_of_pictures

  attribute :user_id, Integer
  attribute :room_id, Integer
  attribute :body, String

  mount_uploader :picture, PictureUploader

  attr_accessor :pictures

  def assign_attributes(params = {})
    @params = params
    # 画像情報からインスタンスを生成する
    pictures_attributes = params[:pictures_attributes]
    @pictures ||= []
    pictures_attributes&.map do |pictures_attribute|
      picture = Picture.new(pictures_attribute)
      @pictures.push(picture)
    end
    super(@params.except(:pictures_attributes))
  end

  # picture情報抜きのsaveメソッドを定義
  def save
    return false if invalid?

    message = Message.new(user_id: user_id, room_id: room_id, body: body)
    message.pictures = pictures if pictures.present?
    message.save!
  end

  private

  def body_or_pictures
    errors.add(:base, 'メッセージには文字か画像が含まれるようにしてください。') if body.blank? && pictures.blank?
  end

  def max_num_of_pictures
    errors.add(:base, "投稿できる画像は#{MAX_PICTURES_COUNT}枚までです。") if pictures.length > MAX_PICTURES_COUNT
  end
end
