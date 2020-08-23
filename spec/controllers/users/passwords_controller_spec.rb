require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :controller do
  let(:user) { create(:user) }

  describe "createアクション" do
    context "パスワード変更のメール送信に失敗する場合" do
      it "メール送信画面にレンダリングする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user.confirm
        post :create, params: { user: { email: "" } }
        expect(response).to have_http_status "200"
        expect(response).to render_template :new
      end
    end
    context "パスワード変更のメール送信に成功する場合" do
      it "ログイン画面にリダイレクトする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user.confirm
        post :create, params: { user: { email: "user@example.com" } }
        expect(response).to have_http_status "302"
        expect(assigns(:user)).to eq user
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  describe "updateアクション" do
    context "パスワード再設定に失敗する場合" do
      it "パスワード入力画面にレンダリングする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user.confirm
        put :update, params: { user: { password: "", password_confirmation: "" } }
        expect(response).to have_http_status "200"
        expect(response).to render_template :edit
      end
    end
    context "パスワード再設定に成功する場合" do
      it "ルート画面にリダイレクトする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user.confirm
        raw = user.send_reset_password_instructions
        put :update, params: { user: { reset_password_token: raw, password: "12345678", password_confirmation: "12345678" } }
        user.reload
        expect(user.valid_password?("12345678")).to eq(true)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
    end
  end

end