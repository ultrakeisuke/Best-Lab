require 'rails_helper'

RSpec.describe Users::ConfirmationsController, type: :request do

  let(:user) { create(:user) }
  
  before do
    parent_category = create(:parent_category)
    children_category = create(:children_category, ancestry: parent_category.id)
  end

  describe "createアクション" do
    context "本人確認のためのメール送信に失敗する場合" do
      it "メールアドレス送信画面にレンダリングする" do
        post user_confirmation_path, params: { user: { email: "" } }
        expect(response).to have_http_status "200"
      end
    end
    context "本人確認のためのメール送信に成功する場合" do
      it "rootにリダイレクトする" do
        post user_confirmation_path, params: { user: { email: user.email } }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
    end
  end

end
