class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  # 論理削除用のgem discardを導入
  include Discard::Model

  mount_uploader :picture, PictureUploader
  validates :name, presence: true, length: { maximum: 50 }
  has_one :profile, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :posts
  has_many :answers
  has_many :replies

  # 新規登録完了時の自動ログインの防止
  def active_for_authentication?
    super && confirmed?
  end

  # エラー時のフラッシュメッセージのキーを返す
  def inactive_message
    confirmed? ? super : :unconfirmed
  end

  # 現在のパスワードを入力することなくプロフィールを更新する
  def update_without_current_password(params, *options)
    params.delete(:current_password)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end
    result = update(params, *options)
    clean_up_passwords
    result
  end

  # ゲストユーザーでログインする際に必要なデータを作成
  def self.guest
    find_or_create_by!(name: 'guest', email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.now
    end
  end

end
