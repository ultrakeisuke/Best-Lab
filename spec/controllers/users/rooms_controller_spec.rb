require 'rails_helper'

RSpec.describe Users::RoomsController, type: :request do
  
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let(:room) { create(:room) }

  before do 
    parent_category = create(:parent_category)
    children_category = create(:children_category, ancestry: parent_category.id)
  end

  describe "createアクション" do
    it "新しいメッセージルームとエントリーを作成" do
      login_user(user)
      # 1つのroomにつき、自分と相手2人分のentryが作成される
      expect { post users_rooms_path, params: { entry: { user_id: another_user.id } } }.to change(Entry, :count).by(2)
      expect(response).to have_http_status "302"
      room = Room.last
      expect(response).to redirect_to users_room_path(room.id)
    end
  end

  describe "indexアクション" do
    before do
      create(:entry, room_id: room.id, user_id: user.id)
      create(:entry, room_id: room.id, user_id: another_user.id)
      create(:message, room_id: room.id, user_id: another_user.id)
    end
    it "リクエストに成功し正常なレスポンスを返す" do
      login_user(user)
      get users_rooms_path
      expect(response).to have_http_status "200"
      # メッセージ相手の情報が表示される
      expect(response.body).to include "#{another_user.name}"
    end
  end

  describe "showアクション" do
    before do
      create(:entry, room_id: room.id, user_id: user.id)
      create(:entry, room_id: room.id, user_id: another_user.id)
    end
    context "他人のメッセージルームに入ろうとした場合" do
      let(:guest_user) { create(:guest_user) }
      it "プロフィール画面にリダイレクトする" do
        login_user(guest_user)
        get users_room_path(room)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_basic_path(guest_user)
      end
    end
    context "自分のメッセージルームに入ろうとした場合" do
      let!(:message) { create(:message, room_id: room.id, user_id: user.id) }
      it "リクエストに成功し、正常なレスポンスを返す" do
        login_user(user)
        get users_room_path(room)
        expect(response).to have_http_status "200"
        # メッセージの表示を確認
        expect(response.body).to include "#{message.body}"
      end
    end
  end

end
