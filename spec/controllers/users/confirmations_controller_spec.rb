require 'rails_helper'

RSpec.describe Users::ConfirmationsController, type: :controller do
  let(:user) { create(:user) }

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "createアクション" do
    context "本人確認のためのメール送信に失敗する場合" do
      it "メールアドレス送信画面にレンダリングする" do
        post :create, params: { id: user.id, user: { email: "" } }
        expect(response).to have_http_status "200"
        expect(response).to render_template :new
      end
    end
    context "本人確認のためのメール送信に成功する場合" do
      it "ログイン画面にリダイレクトする" do
        post :create, params: { id: user.id, user: { email: user.email } }
        expect(response).to have_http_status "302"
        expect(assigns(:user)).to eq user
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

end