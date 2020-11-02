class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :body, length: { maximum: 10000 }
  has_many :pictures, dependent: :destroy
  validates :body_or_pictures, presence: true

  private
  # メッセージに文章か画像が含まれれば送信可能とする
    def body_or_pictures
      body.presence or pictures.presence
    end

end
