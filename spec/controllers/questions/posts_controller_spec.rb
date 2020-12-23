require 'rails_helper'

RSpec.describe Questions::PostsController, type: :controller do
  let(:user) { create(:user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:children_categories) { 3.times.collect { |i| create(:children_category, name: "category#{i}", ancestry: parent_category.id) } }

  describe 'indexアクション' do
    it "すべての質問を表示する" do
      get :index
      expect(response).to have_http_status "200"
      expect(response).to render_template :index      
    end
  end

  describe 'showアクション' do
    let(:post) { create(:post, category_id: children_category.id, user_id: user.id) }
    it "質問詳細画面を表示する" do
      get :show, params: { id: post.id }
      expect(response).to have_http_status "200"
      expect(response).to render_template :show
    end
  end

  describe 'newアクション' do
    it "投稿作成画面を表示する" do
      get :new
      expect(response).to have_http_status "200"
      expect(response).to render_template :new
    end
  end

  describe 'createアクション' do
    context "フォーム入力が無効であった場合" do
      it "投稿に失敗しnewにレンダリングする" do
        login_user(user)
        expect{ post :create, params: { post_form: { category_id: "",
                                                     title: "",
                                                     content: "",
                                                     status: "" } } }.not_to change(Post, :count)
        expect(response).to have_http_status "200"
        expect(response).to render_template :new
      end
    end
    context "フォーム入力が有効であった場合" do
      let(:post_form) { build(:post_form) }
      it "ユーザー詳細画面にリダイレクトする" do
        login_user(user)
        expect{ post :create, params: { post_form: { category_id: children_category.id,
                                                     title: post_form.title,
                                                     content: post_form.content,
                                                     status: "受付中" } } }.to change(Post, :count).by(1)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_basic_path(user.id)
      end
    end
  end

  describe 'editアクション' do
    let(:post) { create(:post, category_id: children_category.id, user_id: user.id) }
    it "投稿編集画面を表示する" do
      login_user(user)
      get :edit, params: { id: post.id }
      expect(response).to have_http_status "200"
      expect(response).to render_template :edit
    end
  end

  describe 'updateアクション' do
    let(:post) { create(:post, category_id: children_category.id, user_id: user.id) }
    context "フォーム入力が無効であった場合" do
      it "編集に失敗しeditにレンダリングする" do
        login_user(user)
        patch :update, params: { id: post.id, post_form: { category_id: "",
                                                           title: "",
                                                           content: "",
                                                           status: ""} }
        expect(response).to have_http_status "200"
        expect(response).to render_template :edit
      end
    end
    context "フォーム入力が有効であった場合" do
      it "編集に成功しユーザー詳細画面にリダイレクトする" do
        login_user(user)
        patch :update, params: { id: post.id, post_form: { category_id: children_category.id,
                                                           title: "title",
                                                           content: "content",
                                                           status: "解決済"} }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_basic_path(user.id)
      end
    end
  end

end
