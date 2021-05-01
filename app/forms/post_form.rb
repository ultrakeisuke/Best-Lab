class PostForm
  MAX_PICTURES_COUNT = 4

  include ActiveModel::Model
  include Virtus.model
  extend CarrierWave::Mount

  STATUS_VALUES = %w[open closed].freeze

  validates :title,   presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 10_000 }
  validates :status, inclusion: { in: STATUS_VALUES }
  validates :category_id, presence: true
  validate :max_num_of_pictures

  attribute :user_id,        Integer
  attribute :category_id,    Integer
  attribute :title,          String
  attribute :content,        String
  attribute :status,         String
  attribute :best_answer_id, Integer

  mount_uploader :picture, PictureUploader

  attr_accessor :pictures, :post

  def initialize(post = Post.new)
    @post = post
    self.attributes = @post.attributes if @post.persisted?
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
    # 画像以外の情報でpostを更新する
    @params.delete(:pictures_attributes)
    @post.assign_attributes(@params) if @post.persisted?
    super(@params)
  end

  # ベストアンサー用フォームに不正な値があった場合は処理を中断する
  def check_best_answer_params(params)
    # 質問に紐づく回答以外のidを入力した場合、またはstatusが「closed」以外を入力した場合にfalseを返す
    return false if post.answers.ids.exclude?(params[:best_answer_id].to_i) || params[:status] != 'closed'
  end

  def save
    return false if invalid?

    if @post.persisted?
      @post.pictures = pictures if pictures.present?
      @post.save!
    else
      post = Post.new(user_id: user_id,
                      category_id: category_id,
                      title: title,
                      content: content,
                      status: status)
      post.pictures = pictures if pictures.present?
      post.save!
    end
  end

  private

  def max_num_of_pictures
    errors.add(:base, "投稿できる画像は#{MAX_PICTURES_COUNT}枚までです。") if pictures.length > MAX_PICTURES_COUNT
  end
end
