require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  let(:user) { create(:user) }

  describe "newアクション" do
    it "正常なレスポンスとnewページを返す" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      get :new
      expect(response).to have_http_status "200"
      expect(response).to render_template :new
    end
  end
  describe "createアクション" do
    context "ログインに失敗した場合" do
      it "取り扱い説明画面にリダイレクトする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user.confirm
        post :create, params: { user: { email: "", password: "" } }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to about_path
      end
    end
    context "ログインに成功した場合" do
      it "ホーム画面にリダイレクトする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user.confirm
        post :create, params: { user: { email: "user@example.com", password: "1234567" } }
        expect(response).to have_http_status "302"
        expect(assigns(:user)).to eq user
        expect(response).to redirect_to root_path
      end
    end
  end
  describe "destroyアクション" do
    it "正常なレスポンスとページを返す" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user.confirm
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to about_path
    end
  end

end