require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:message) { create(:message, user_id: user.id, room_id: room.id)}
  
  it "メッセージの文字と画像が空なら無効" do
    create_list(:picture, 4, message_id: message.id)
    message.body = ""
    expect(message).not_to be_valid
  end

  it "メッセージの画像が空で文字が空でないなら有効" do
    message.body = "a"
    expect(message).to be_valid
  end

end
