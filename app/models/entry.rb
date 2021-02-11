class Entry < ApplicationRecord
  belongs_to :user
  belongs_to :room

  # メッセージ相手と部屋の情報を取得
  def self.another_entries(user)
    my_room_ids = []
    my_room_ids << user.entries.map { |entry| entry.room_id }
    where(room_id: my_room_ids).where.not(user_id: user)
  end

  # 配列からメッセージ相手と部屋の情報を抽出
  def self.partner_of(user)
    where.not(user_id: user).first
  end

  # メッセージの作成時刻をもとにユーザー情報をソート
  def self.sorted_entries(user)
    last_messages = []
    find_each do |another_entry|
    # メッセージが１つでも存在する部屋のメッセージを取得
      last_messages << another_entry.room.messages.last if another_entry.room.messages.present?
    end
    # メッセージの作成時刻をもとにソート
    sorted_messages = last_messages.sort_by! { |a| a[:created_at] }.reverse
    sorted_entries = sorted_messages.map { |sorted_message| sorted_message.room.entries.partner_of(user) }
    sorted_entries
  end

  # ダイレクトメッセージ用の部屋を相手と共有しているか確認する処理
  def self.find_or_create_partner(current_user, another_user)
    current_entries = Entry.where(user_id: current_user)
    another_entries = Entry.where(user_id: another_user)
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
    # 共通の部屋を持たない、もしくはentryを持っていない場合
    @is_room = nil
    @room_id = nil
    @entry = Entry.new
    return @is_room, @room_id, @entry
  end

end
