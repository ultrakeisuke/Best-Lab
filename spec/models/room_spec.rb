require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
  let!(:current_entry) { create(:entry, user_id: user.id, room_id: room.id, notice: true) }

  describe 'remove_noticeメソッド' do
    it 'noticeカラムがfalseを返す' do
      room.remove_notice(user)
      expect(current_entry.reload.notice).to eq false
    end
  end

  describe 'check_noticeメソッド' do
    it '通知があるのでnoticeカラムがtrueを返す' do
      room.check_notice(user)
      expect(current_entry.reload.notice).to eq true
    end
  end
end
