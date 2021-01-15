require 'rails_helper'

RSpec.describe Users::MessagesController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let(:room) { create(:room) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
    
  describe "createアクション" do
    context "メッセージが空白だった場合" do
      it "メッセージは保存されず、メッセージ画面にリダイレクトする" do
        login_user(user)
        expect{ post :create, params: { message_form: { user_id: user.id, room_id: room.id, body: "" } } }.not_to change(Message, :count)
        expect(response).to have_http_status "200"
        expect(response).to render_template "users/rooms/show"
      end
    end

    context "メッセージが10000文字以上だった場合" do
      it "メッセージは保存されず、メッセージ画面にリダイレクトする" do
        login_user(user)
        expect{ post :create, params: { message_form: { user_id: user.id, room_id: room.id, body: "a"*100001 } } }.not_to change(Message, :count)
        expect(response).to have_http_status "200"
        expect(response).to render_template "users/rooms/show"
      end
    end

    context "メッセージが10000文字以内だった場合" do
      it "メッセージは保存され、メッセージ画面にリダイレクトする" do
        login_user(user)
        expect{ post :create, params: { message_form: { user_id: user.id, room_id: room.id, body: "MyText" } } }.to change(Message, :count).by(1)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_room_path(room)
      end
    end
  end


  describe "destroyアクション" do
    context "自分のメッセージを削除する場合" do
      it "メッセージを削除し、再度メッセージ画面を表示する" do
        login_user(user)
        message = Message.create(user_id: user.id, room_id: room.id, body: "MyText")
        expect { delete :destroy, params: { id: message.id } }.to change(Message, :count).by(-1)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_room_path(room)
      end
    end

    context "他のユーザーのメッセージを削除しようとした場合" do
      it "メッセージは削除できない" do
        login_user(user)
        message = Message.create(user_id: another_user.id, room_id: room.id, body: "MyText")
        expect { delete :destroy, params: { id: message.id } }.not_to change(Message, :count)
        expect(response).to have_http_status "302"
      end
    end
  end

end
