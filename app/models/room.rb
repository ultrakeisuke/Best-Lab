class Room < ApplicationRecord
  has_many :entries, dependent: :destroy
  has_many :messages, dependent: :destroy

  # メッセージルームに入ると通知が外れる処理
  def remove_notice(user)
    entry = Entry.find_by(user_id: user, room_id: self)
    entry.update(notice: false) if entry&.notice
  end

  # 通知の有無を返す処理
  def check_notice(user)
    checked_entry = Entry.find_by(user_id: user, room_id: self)
    checked_entry&.notice
  end
end
