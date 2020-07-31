class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  validates :name, presence: true
  validates :profile, length: { maximum: 200 }

  # プロフィールのバリデーションを追加
 

  # 新規登録完了時の自動ログインの防止
  def active_for_authentication?
    super && confirmed?
  end

  # エラー時のフラッシュメッセージのキーを返す
  def inactive_message
    confirmed? ? super : :needs_confirmation
  end

end
