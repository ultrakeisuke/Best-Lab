require 'rails_helper'

RSpec.describe Users::RoomsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }

  describe "createアクション" do
    context "プロフィール画面でメッセージボタンをクリックした場合" do
      it "新しいメッセージルームとエントリーを作成" do
        login_user(user)
        # 1つのroomにつき、自分と相手2人分のentryが作成される
        expect { post :create, params: { entry: { user_id: another_user.id } } }.to change(Entry, :count).by(2)
        # 自分の相手のエントリーが作成される
        expect(assigns(:current_entry)).to eq user.entries.last
        expect(assigns(:another_entry)).to eq another_user.entries.last
        expect(response).to have_http_status "302"
        room = Room.last
        expect(response).to redirect_to users_room_path(room.id)
      end
    end
  end

  describe "indexアクション" do
    it "インスタンスが期待した値を返し、正常なレスポンスを返す" do
      create_list(:rooms, 5)
      create_list(:current_entries, 5, user_id: user.id)
      current_entries = user.entries

      login_user(user)
      get :index
      expect(assigns(:current_entries)).to eq current_entries
      expect(response).to have_http_status "200"
      expect(response).to render_template :index
    end
  end

end