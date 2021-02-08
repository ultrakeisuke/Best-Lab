require 'rails_helper'

RSpec.describe Users::SessionsController, type: :controller do
  let(:user) { create(:user) }
  let(:guest_user) { create(:guest_user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    # ユーザーとゲストユーザーはアカウント認証済みとする
    user.confirm
    guest_user.confirm
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  describe "newアクション" do
    it "正常なレスポンスとnewページを返す" do
      get :new
      expect(response).to have_http_status "200"
      expect(response).to render_template :new
    end
  end
  describe "createアクション" do
    context "ログインに失敗した場合" do
      it "ログイン画面を表示する" do
        post :create, params: { user: { email: "", password: "" } }
        expect(response).to have_http_status "200"
        expect(response).to render_template :new
      end
    end
    context "ログインに成功した場合" do
      it "ホーム画面にリダイレクトする" do
        post :create, params: { user: { email: "user@example.com", password: "1234567" } }
        expect(response).to have_http_status "302"
        expect(assigns(:user)).to eq user
        expect(response).to redirect_to users_basic_path(user)
      end
    end
    context "ゲストユーザーでログインした場合" do
      it "ホーム画面にリダイレクトする" do
        post :new_guest, params: { user: { name: guest_user.name, email: guest_user.email } }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_basic_path(guest_user)
      end
    end
    context "退会済みのユーザーがログインしようとした場合" do
      let!(:discarded_user) { create(:another_user, discarded_at: Time.now) }
      it "新規登録画面にリダイレクトする" do
        post :create, params: { user: { email: discarded_user.email, password: discarded_user.password } }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end
  describe "destroyアクション" do
    it "正常なレスポンスとページを返す" do
      delete :destroy
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end

end
