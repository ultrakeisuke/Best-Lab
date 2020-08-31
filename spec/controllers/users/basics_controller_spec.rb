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
    it "正常なレスポンスとshowページを返す" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status "200"
      expect(response).to render_template :show
      expect(assigns(:user)).to eq user
    end
  end

end