require 'rails_helper'

describe UsersController, type: :controller do
  let(:user) { create(:user) }

  # showアクションのテスト
  describe 'GET #show' do
    # 正常なレスポンスとshowページを返す
    it "responds successfully" do
      get :show, params: { id: user.id }
      expect(response).to have_http_status "200"
      expect(response).to render_template :show
      expect(assigns(:user)).to eq user
    end
  end

end