class MessageForm
  MAX_PICTURES_COUNT = 4

  # ActionPackやActionViewと連携。validationを使えるようにする
  include ActiveModel::Model
  # オブジェクト生成の際にパラメータに指定する属性(attribute)を定義できるようにする
  include Virtus.model
  # Model以外でCarrierWaveを使えるようにする
  extend CarrierWave::Mount

  validates :body, length: { maximum: 10000 }
  validates :body_or_pictures, presence: true
  validate :max_num_of_pictures

  attribute :user_id, Integer
  attribute :room_id, Integer
  attribute :body, String

  mount_uploader :picture, PictureUploader

  attr_accessor :pictures

  # newメソッドでフォームオブジェクトを生成する際に実行されるセッターを定義
  def pictures_attributes=(attributes)
    # 投稿する画像を格納するために空の配列@picturesを作成
    @pictures ||= []
    # attributesから値を取り出し、それをもとにpictureインスタンスを生成
    attributes&.map do |attribute|
      picture = Picture.new(attribute)
      # pictureを@picturesに格納
      @pictures.push(picture)
    end
  end

  # picture情報抜きのsaveメソッドを定義
  def save
    return false if invalid?
    message = Message.new(user_id: user_id, room_id: room_id, body: body)
    message.pictures = pictures if pictures.present?
    message.save!
  end

  private

    # メッセージに文章か画像が含まれるよう制限する
    def body_or_pictures
      self.body.presence or self.pictures.presence
    end

    def max_num_of_pictures
      errors.add(:base, "投稿できる画像は#{MAX_PICTURES_COUNT}枚までです。") if self.pictures && self.pictures.length > MAX_PICTURES_COUNT
    end

end
