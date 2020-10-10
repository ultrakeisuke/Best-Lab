require 'rails_helper'

RSpec.describe Users::MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:room) { create(:room) }
    
  describe "createアクション" do
    context "メッセージが空白だった場合" do
      it "メッセージは保存されず、メッセージ画面にリダイレクトする" do
        login_user(user)
        expect{ post :create, params: { message: { user_id: user.id, room_id: room.id, body: "" } } }.not_to change(Message, :count)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_room_path(room.id)
      end
    end

    context "メッセージが10000文字以上だった場合" do
      it "メッセージは保存されず、メッセージ画面にリダイレクトする" do
        login_user(user)
        expect{ post :create, params: { message: { user_id: user.id, room_id: room.id, body: "a"*100001 } } }.not_to change(Message, :count)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_room_path(room.id)
      end
    end

    context "メッセージが10000文字以内だった場合" do
      it "メッセージは保存され、メッセージ画面にリダイレクトする" do
        login_user(user)
        expect{ post :create, params: { message: { user_id: user.id, room_id: room.id, body: "MyText" } } }.to change(Message, :count).by(1)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_room_path(room.id)
      end
    end
  end

end