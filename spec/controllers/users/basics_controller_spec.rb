require 'rails_helper'

RSpec.describe Users::BasicsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let(:posts) { create_list(:post, 2, user_id: another_user.id, category_id: children_category.id) }

  describe 'showアクション' do
    context "相手が共通のメッセージルームを持たないユーザーの場合" do
      before do
        room1 = create(:room)
        room2 = create(:room)
        create(:entry, user_id: user.id, room_id: room1.id)
        create(:entry, user_id: another_user.id, room_id: room2.id)
      end
      it "インスタンスが期待した値を返し、正常なレスポンスを返す" do
        login_user(user)
        get :show, params: { id: another_user.id }
        expect(assigns(:posts)).to eq posts
        # 共通のメッセージルームがないので@is_roomがnilを返す
        expect(assigns(:is_room)).to eq nil
        expect(response).to have_http_status "200"
        expect(response).to render_template :show
      end
    end
    context "相手が共通のメッセージルームを持つユーザーの場合" do
      before do
        room = create(:room)
        create(:entry, user_id: user.id, room_id: room.id)
        create(:entry, user_id: another_user.id, room_id: room.id)
      end
      it "インスタンスが期待した値を返し、正常なレスポンスを返す" do
        login_user(user)
        get :show, params: { id: another_user.id }
        expect(assigns(:posts)).to eq posts
        # 共通のメッセージルームがあるので@is_roomがtrueを返す
        expect(assigns(:is_room)).to eq true
        expect(response).to have_http_status "200"
        expect(response).to render_template :show
      end
    end
  end

end
