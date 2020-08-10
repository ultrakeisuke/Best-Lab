class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  mount_uploader :picture, PictureUploader
  validates :name, presence: true, length: { maximum: 50 }
  validates :affiliation, inclusion: { in: [true, false] }
  validates :profile, length: { maximum: 200 }


  # 新規登録完了時の自動ログインの防止
  def active_for_authentication?
    super && confirmed?
  end

  # エラー時のフラッシュメッセージのキーを返す
  def inactive_message
    confirmed? ? super : :unconfirmed
  end

  # 現在のパスワードを入力することなくプロフィールを更新する
  def update_with_password(params, *options)
    params.delete(:current_password)
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete(:password)
      params.delete(:password_confirmation)
    end

    result = update(params, *options)

    clean_up_passwords # これの説明できるようになっておく
    result
  end

end
