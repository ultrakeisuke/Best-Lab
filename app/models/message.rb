class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :pictures, as: :imageable, dependent: :destroy

  # メッセージ相手に通知を送信する処理
  def send_notice_to_partner
    partner = Entry.where(room_id: self.room_id).where.not(user_id: self.user_id).first
    partner.update(notice: true) if partner.notice == false
  end

end
