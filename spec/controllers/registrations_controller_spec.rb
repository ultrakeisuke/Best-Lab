require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:user) { create(:user) }

  describe "updateアクション" do
    context "プロフィール編集に失敗した場合" do
      it "プロフィール編集画面にレンダリングする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user.confirm
        sign_in user
        put :update, params: { user: { profile: "1"*201 } }
        expect(response).to have_http_status "200"
        expect(response).to render_template :edit
      end
    end
    context "プロフィール編集に成功した場合" do
      it "プロフィール画面にリダイレクトする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user.confirm
        sign_in user
        put :update, params: { user: { profile: "1"*200 } }
        expect(user.reload.profile).to eq "1"*200
        expect(response).to have_http_status "302"
        expect(assigns(:user)).to eq user
        expect(response).to redirect_to users_profile_path(user)
      end
    end
  end

end