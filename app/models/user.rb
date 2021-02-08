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

  # アカウント認証が済むまでログインできない処理
  def active_for_authentication?
    super && confirmed?
  end

  # 上記のメソッドがfalseを返した場合にエラーメッセージを表示する処理
  def inactive_message
    confirmed? ? super : :unconfirmed
  end

  # 現在のパスワード入力なしでアカウント情報を更新
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

  # ユーザーの退会処理
  def inactivate_account
    self.update(name: "退会済みユーザー")
    self.discard
  end

  # プロフィール画像の有無で表示する画像を変化する処理
  def profile_picture
    self.picture.present? ? self.picture.url : "default.jpeg"
  end

  # ダイレクトメッセージ用の部屋を相手と共有しているか確認する処理
  def find_or_create_room_for(user)
    current_entries = Entry.where(user_id: self)
    another_entries = Entry.where(user_id: user.id)
    current_entries.each do |current_entry|
      another_entries.each do |another_entry|
        # 共通の部屋を持つ場合
        if current_entry.room_id == another_entry.room_id
          # 共通の部屋があることを示す@is_roomをtrueにする
          @is_room = true
          @room_id = current_entry.room_id
          return @is_room, @room_id
        end
      end
    end
    # 共通の部屋を持たない場合
    unless @is_room
      @is_room = nil
      @room_id = nil
      @entry = Entry.new
      return @is_room, @room_id, @entry
    end
  end

end
