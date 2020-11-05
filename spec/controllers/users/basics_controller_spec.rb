require 'rails_helper'

RSpec.describe Users::BasicsController, type: :controller do
  let(:user) { create(:user) }

  describe 'indexアクション' do
    context "ログインしていない場合" do
      it "ログイン画面にリダイレクトする" do
        get :index
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "ログインしている場合" do
      it "indexページを返す" do
        login_user(user)
        get :index
        expect(response).to have_http_status "200"
        expect(response).to render_template :index
      end
    end
  end

  describe 'showアクション' do
    let(:another_user) { create(:another_user) }
    it "インスタンスが期待した値を返し、正常なレスポンスを返す" do
      create_list(:rooms, 5)
      create_list(:current_entries, 5, user_id: user.id)
      create_list(:another_entries, 1, user_id: another_user.id)
      current_entry = Entry.where(user_id: user.id)
      another_entry = Entry.where(user_id: another_user.id)
      
      login_user(user)
      get :show, params: { id: another_user.id }
      expect(assigns(:user)).to eq another_user
      expect(assigns(:current_entry)).to eq current_entry
      expect(assigns(:another_entry)).to eq another_entry
      expect(response).to have_http_status "200"
      expect(response).to render_template :show
    end
  end

end
