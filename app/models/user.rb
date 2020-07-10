class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :name, presence: true
  validates :profile, length: { maximum: 200 }

  # 新規登録時にパスワードが空でも送信できるようにする
  def password_required?
    super && confirmed?
  end

  # confirmed_at に最初は値が入っていないので false となりログインを防げる
  def active_for_authentication?
    super && confirmed?
  end

  # エラー時のフラッシュメッセージのキーを返す
  def inactive_message
    confirmed? ? super : :needs_confirmation
  end

end
