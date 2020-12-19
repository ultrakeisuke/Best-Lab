class PostForm
  include ActiveModel::Model
  include Virtus.model
  extend CarrierWave::Mount

  validates :title,   presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 10000 }

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
    post.assign_attributes(@params) if @post.persisted?
    super(@params)
  end

  def save
    return false if invalid?
    if @post.persisted?
      @post.pictures = pictrues if pictures.present?
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
  
end
