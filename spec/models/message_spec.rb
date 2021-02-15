require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:user) { create(:user) }
  let(:partner) { create(:another_user) }

  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }

  # メッセージ相手が通知を受信するためのエントリーを作成
  let(:room) { create(:room) }
  let!(:partner_entry) { create(:entry, user_id: partner.id, room_id: room.id) }

  describe "send_notice_to_partnerメソッド" do
    it "メッセージ相手に通知を送信する" do
      message = create(:message, user_id: user.id, room_id: room.id)
      message.send_notice_to_partner
      expect(partner_entry.reload.notice).to eq true
    end
  end

end
