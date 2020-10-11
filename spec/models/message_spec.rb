require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:message) { create(:message, user_id: user.id, room_id: room.id)}
  
  it "メッセージの文字と画像が空なら無効" do
    message.body = ""
    message.pictures.blank?
    expect(message).not_to be_valid
  end

end
