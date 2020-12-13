class PostForm
  include ActiveModel::Model
  include Virtus.model

  validates :title,   presence: true, length: { maximum: 50 }
  validates :content, presence: true, length: { maximum: 10000 }

  attribute :user_id,     Integer
  attribute :category_id, Integer
  attribute :title,       String
  attribute :content,     String
  attribute :status,      Boolean

  attr_accessor :pictures

  def initialize(post = Post.new)
    @post = post
    self.attributes = @post.attributes if @post.persisted?
  end

  def assign_attributes(params = {})
    @params = params
    @post.assign_attributes(params) if @post.persisted?
    super(params)
  end

  def save
    return false if invalid?
    if @post.persisted?
      @post.save!
    else
      post = Post.new(user_id: user_id,
                      category_id: category_id,
                      title: title,
                      content: content)
      post.save!
    end
  end
  
end
