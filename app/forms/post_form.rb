class PostForm
  MAX_PICTURES_COUNT = 4

  include ActiveModel::Model
  include Virtus.model
  extend CarrierWave::Mount

  validates :title,   presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 10000 }
  validate :max_num_of_pictures

  attribute :user_id,     Integer
  attribute :category_id, Integer
  attribute :title,       String
  attribute :content,     String
  attribute :status,      Boolean

  mount_uploader :picture, PictureUploader

  attr_accessor :pictures

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

  def save
    return false if invalid?
    if @post.persisted?
      @post.pictures = pictures if pictures.present?
      @post.save!
    else
      post = Post.new(user_id: user_id,
                      category_id: category_id,
                      title: title,
                      content: content)
      post.pictures = pictures if pictures.present?
      post.save!
    end
  end

  private

  def max_num_of_pictures
    errors.add(:base, "投稿できる画像は#{MAX_PICTURES_COUNT}枚までです。") if self.pictures.length > MAX_PICTURES_COUNT
  end
  
end
