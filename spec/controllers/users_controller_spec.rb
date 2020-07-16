require 'rails_helper'

describe UsersController, type: :controller do

  # indexページ用テスト
  describe 'GET #index' do

    # 正常なレスポンスの確認
    it "responds successfully" do
      get :index
      expect(response).to be_successful
    end

    # indexページを表示するか確認
    it "render the :index template" do
      get :index
      expect(response).to render_template :index
    end

    # 200レスポンスを返すか確認
    it "returns a 200 response" do
      get :index
      expect(response).to have_http_status "200"
    end
  end

  # showページ用テスト
  describe 'GET #show' do
    before do
      @user = User.create(
        id: "1",
        name: "foo",
        email: "foo@example.com",
      )
    end

    # 正常なレスポンスの確認
    it "responds successfully" do
      sign_in @user
      get :show, params: {id: @user.id}
      expect(response).to be_successful
    end

    # indexページを表示するか確認
    it "render the :show template" do
      sign_in @user
      get :show, params: {id: @user.id}
      expect(response).to render_template :show
    end

    # 200レスポンスを返すか確認
    it "returns a 200 response" do
      sign_in @user
      get :show, params: {id: @user.id}
      expect(response).to have_http_status "200"
    end
  end

end