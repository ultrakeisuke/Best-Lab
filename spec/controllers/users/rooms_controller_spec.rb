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
      create_list(:another_entries, 5, user_id: another_user.id)
      # userが持つすべてのentryを定義
      current_entries = user.entries
      
      # userが持つすべてのroom_idを定義
      my_room_ids = []
      current_entries.each do |entry|
        my_room_ids << entry.room_id
      end

      # another_userがuserと共有するentryを定義
      another_entries = Entry.where(room_id: my_room_ids).where.not(user_id: user.id)

      login_user(user)
      get :index
      expect(assigns(:current_entries)).to eq current_entries
      expect(assigns(:another_entries)).to eq another_entries
      expect(response).to have_http_status "200"
      expect(response).to render_template :index
    end
  end

  describe "showアクション" do
    let(:room) { create(:room) }
    let(:current_entry) { create(:entry, user_id: user.id, room_id: room.id) }
    it "インスタンスが期待した値を返し、正常なレスポンスを返す" do
      # another_userがuserと共有するentryを作成
      create(:entry, user_id: another_user.id, room_id: room.id)
      # another_userがuserと共有するentryをanother_entryに定義
      another_entry = room.entries.find_by('user_id != ?', user.id)

      login_user(user)
      get :show, params: { id: room.id }
      expect(response).to have_http_status "200"
      expect(assigns(:another_entry)).to eq another_entry
      expect(response).to render_template :show
    end
  end

end