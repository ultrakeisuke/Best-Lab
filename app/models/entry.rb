class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :room
  include Partner

  # メッセージが１つでも存在する部屋のメッセージを返す処理
  def include_message
    self.room.messages.last if self.room.messages.present?
  end

end
