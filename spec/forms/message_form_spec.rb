require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let(:message) { build(:message_form, user_id: user.id, room_id: room.id, body: '') }

  it 'メッセージの文字と画像が空なら無効' do
    pictures = []
    message.pictures = pictures
    expect(message).not_to be_valid
  end

  it 'メッセージの画像が空で文字が空でないなら有効' do
    message.body = 'message'
    pictures = []
    message.pictures = pictures
    expect(message).to be_valid
  end

  context 'メッセージの文字が空で画像が空でない場合' do
    it '画像を5枚以上添付した場合は無効' do
      pictures = build_list(:picture, 5)
      message.pictures = pictures
      expect(message).not_to be_valid
      expect(message.errors[:base]).to include('投稿できる画像は4枚までです。')
    end
    it '画像を4枚添付した場合は有効' do
      pictures = build_list(:picture, 4)
      message.pictures = pictures
      expect(message).to be_valid
    end
  end
end
