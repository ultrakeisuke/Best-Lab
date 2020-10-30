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

  mount_uploader :picture, PictureUploader

  attr_accessor :pictures

  # newでformオブジェクトを生成する際に実行されるセッターを定義
  def pictures_attributes=(attributes)
    # 投稿する画像を格納するために空の配列@picturesを作成
    @pictures ||= []
    # attributesから値を取り出し、それをもとにpictureインスタンスを生成
    attributes.each do |i, picture_params|
      picture = Picture.new(picture_params)
      # pictureを@picturesに格納
      @pictures.push(picture)
    end
  end

  # picture情報抜きのsaveメソッドを定義
  def save
    message = Message.new(user_id: user_id, room_id: room_id, body: body)
    message.save!
  end

  private

    # メッセージに文章か画像が含まれるよう制限する
    def body_or_pictures
      body.presence or pictures.presence
    end

end
