class AnswerForm
  MAX_PICTURES_COUNT = 4

  include ActiveModel::Model
  include Virtus.model
  extend CarrierWave::Mount

  validates :body, length: { maximum: 10_000 }
  validate :body_or_pictures
  validate :max_num_of_pictures

  attribute :user_id, Integer
  attribute :post_id, Integer
  attribute :body, String

  mount_uploader :picture, PictureUploader

  attr_accessor :pictures

  def initialize(answer = Answer.new)
    @answer = answer
    self.attributes = @answer.attributes if @answer.persisted?
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
    # 画像以外の情報でanswerを更新する
    @params.delete(:pictures_attributes)
    @answer.assign_attributes(@params) if @answer.persisted?
    super(@params)
  end

  def save
    return false if invalid?

    if @answer.persisted?
      @answer.pictures = pictures if pictures.present?
      @answer.save!
    else
      answer = Answer.new(user_id: user_id,
                          post_id: post_id,
                          body: body)
      answer.pictures = pictures if pictures.present?
      answer.save!
    end
  end

  private

  # 回答にコメントか画像が含まれるよう制限する
  def body_or_pictures
    errors.add(:base, 'コメントか画像を送信してください。') if body.blank? && pictures.blank?
  end

  def max_num_of_pictures
    errors.add(:base, "投稿できる画像は#{MAX_PICTURES_COUNT}枚までです。") if pictures.length > MAX_PICTURES_COUNT
  end
end
