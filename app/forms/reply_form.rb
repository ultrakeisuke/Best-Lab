class ReplyForm
  MAX_PICTURES_COUNT = 4

  include ActiveModel::Model
  include Virtus.model
  extend CarrierWave::Mount

  validates :body, length: { maximum: 10_000 }
  validate :body_or_pictures
  validate :max_num_of_pictures

  attribute :user_id, Integer
  attribute :answer_id, Integer
  attribute :body, String

  mount_uploader :picture, PictureUploader

  attr_accessor :pictures

  def initialize(reply = Reply.new)
    @reply = reply
    self.attributes = @reply.attributes if @reply.persisted?
  end

  def assign_attributes(params = {})
    @params = params
    # 画像情報からインスタンスを生成する
    pictures_attributes = params[:pictures_attributes]
    @pictures ||= []
    pictures_attributes&.map do |pictures_attribute|
      picture = Picture.new(pictures_attribute)
      @pictures.push(picture)
    end
    # 画像以外の情報でreplyを更新する
    @params.delete(:pictures_attributes)
    @reply.assign_attributes(@params) if @reply.persisted?
    super(@params)
  end

  def save
    return false if invalid?

    if @reply.persisted?
      @reply.pictures = pictures if pictures.present?
      @reply.save!
    else
      reply = Reply.new(user_id: user_id,
                        answer_id: answer_id,
                        body: body)
      reply.pictures = pictures if pictures.present?
      reply.save!
    end
  end

  private

  # リプライにコメントか画像が含まれるよう制限する
  def body_or_pictures
    errors.add(:base, 'コメントか画像を送信してください。') if body.blank? && pictures.blank?
  end

  def max_num_of_pictures
    errors.add(:base, "投稿できる画像は#{MAX_PICTURES_COUNT}枚までです。") if pictures.length > MAX_PICTURES_COUNT
  end
end
