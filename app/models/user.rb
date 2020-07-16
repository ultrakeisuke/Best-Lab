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

  # パスワードのバリデーションを追加
  def password_match?
    self.errors[:password] << "を入力してください。" if password.blank?
    self.errors[:password_confirmation] << "を入力してください。" if password_confirmation.blank?
    self.errors[:password_confirmation] << "が間違っています。" if password != password_confirmation
    password == password_confirmation && !password.blank?
  end  

  # confirmed_at に最初は値が入っていないのでfalseが返りログインを防ぐ
  def active_for_authentication?
    super && confirmed?
  end

  # エラー時のフラッシュメッセージのキーを返す
  def inactive_message
    confirmed? ? super : :needs_confirmation
  end

end
