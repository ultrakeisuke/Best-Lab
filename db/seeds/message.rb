# 初期ダイレクトメッセージ
# メッセージルーム
rooms = []
10.times do |_n|
  rooms << Room.new
end
Room.import rooms

# ゲストユーザーのエントリー
current_entries = []
10.times do |n|
  current_entries << Entry.new(notice: true,
                               room_id: n + 1,
                               user_id: 1001)
end
Entry.import current_entries

# その他のユーザーのエントリー
another_entries = []
10.times do |n|
  another_entries << Entry.new(room_id: n + 1,
                               user_id: n + 1)
end
Entry.import another_entries

# ゲストユーザーのメッセージ
current_messages = []
10.times do |n|
  current_messages << Message.new(room_id: n + 1,
                                  user_id: 1001,
                                  body: '初めまして。guestと申します。研究のことでお聞きしたいことがあります。どうぞよろしくお願いします。')
end
Message.import current_messages

# ゲストユーザーに対するメッセージ
another_messages = []
10.times do |n|
  another_messages << Message.new(room_id: n + 1,
                                  user_id: n + 1,
                                  body: 'guestさん、メッセージありがとうございます。説明が難しい場合は画像を添付いただけると助かります。よろしくお願いします。')
end
Message.import another_messages
