require 'rails_helper'

RSpec.describe Users::RoomsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let(:guest_user) { create(:guest_user) }
  let(:room) { create(:room) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }

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
    let(:users) { create_list(:test_users, 3) }
    let(:rooms) { create_list(:rooms, 3) }
    let!(:entry1) { create(:entry, room_id: rooms[0].id, user_id: users[0].id) }
    let!(:entry2) { create(:entry, room_id: rooms[1].id, user_id: users[0].id) }
    let!(:entry3) { create(:entry, room_id: rooms[2].id, user_id: users[0].id) }

    before do
      create(:entry, room_id: rooms[0].id, user_id: user.id)
      create(:entry, room_id: rooms[1].id, user_id: user.id)
      create(:entry, room_id: rooms[2].id, user_id: user.id)
      create(:message, room_id: rooms[0].id, user_id: user.id, created_at: Time.current)
      create(:message, room_id: rooms[1].id, user_id: user.id, created_at: Time.current + 1.second)
    end

    it "インスタンスが期待した値を返し、正常なレスポンスを返す" do
      login_user(user)
      get :index
      # user_id != user.idとなるentryをanother_entriesとする
      another_entries = [entry1, entry2, entry3]
      expect(assigns(:another_entries)).to eq another_entries
      # メッセージを持つentry1, entry2をanother_entriesから抽出
      # メッセージの投稿が新しい方から表示されるのでentry2, entry1の順に表示
      sorted_entries = [entry2, entry1]
      expect(assigns(:sorted_entries)).to eq sorted_entries
      expect(response).to have_http_status "200"
      expect(response).to render_template :index
    end
  end

  describe "showアクション" do
    before do
      create(:entry, user_id: user.id, room_id: room.id)
    end
    let!(:another_entry) { create(:entry, user_id: another_user.id, room_id: room.id) }
    context "他人のメッセージルームに入ろうとした場合" do
      it "プロフィール画面にリダイレクトする" do
        login_user(guest_user)
        get :show, params: { id: room.id }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_basic_path(guest_user)
      end
    end
    context "自分のメッセージルームに入ろうとした場合" do
      it "インスタンスが期待した値を返し、正常なレスポンスを返す" do
        login_user(user)
        get :show, params: { id: room.id }
        expect(response).to have_http_status "200"
        expect(assigns(:another_entry)).to eq another_entry
        expect(response).to render_template :show
      end
    end
  end

end
