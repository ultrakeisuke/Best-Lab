class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :pictures, as: :imageable, dependent: :destroy

  # メッセージ相手に通知を送信する処理
  def send_notice_to_partner
    partner = Entry.where(room_id: room_id).where.not(user_id: user_id).first
    partner.update(notice: true) unless partner&.notice
  end
end
