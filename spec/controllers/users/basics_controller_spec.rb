require 'rails_helper'

RSpec.describe Users::BasicsController, type: :controller do
  let(:user) { create(:user) }

  describe 'showアクション' do
    it "正常なレスポンスとshowページを返す" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status "200"
      expect(response).to render_template :show
      expect(assigns(:user)).to eq user
    end
  end

end