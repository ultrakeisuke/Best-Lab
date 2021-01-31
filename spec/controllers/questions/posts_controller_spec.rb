require 'rails_helper'

RSpec.describe Questions::PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }

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
        expect(response).to redirect_to users_basic_path(user)
      end
    end
  end

  describe 'editアクション' do
    let!(:post) { create(:post, category_id: children_category.id, user_id: user.id) }
    let!(:another_post) { create(:post, category_id: children_category.id, user_id: another_user.id) }
    context "他人の質問編集画面を見ようとした場合" do
      it "ログインユーザーの詳細画面にリダイレクトする" do
        login_user(user)
        get :edit, params: { id: another_post.id }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_basic_path(user)
      end
    end
    context "自分の質問編集画面を見ようとした場合" do
      it "投稿編集画面を表示する" do
        login_user(user)
        get :edit, params: { id: post.id }
        expect(response).to have_http_status "200"
        expect(response).to render_template :edit
      end
    end
  end

  describe 'updateアクション' do
    let!(:post) { create(:post, category_id: children_category.id, user_id: user.id) }
    let!(:another_post) { create(:post, category_id: children_category.id, user_id: another_user.id) }
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
    context "他人の質問を編集しようとした場合" do
      it "編集に失敗しログインユーザーの詳細画面にリダイレクトする" do
        login_user(user)
        patch :update, params: { id: another_post.id, post_form: { category_id: children_category.id,
                                                                   title: "title",
                                                                   content: "content",
                                                                   status: "解決済"} }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_basic_path(user)
      end
    end
    context "フォーム入力が有効であった場合" do
      it "編集に成功し質問詳細画面にリダイレクトする" do
        login_user(user)
        patch :update, params: { id: post.id, post_form: { category_id: children_category.id,
                                                           title: "title",
                                                           content: "content",
                                                           status: "解決済"} }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to questions_post_path(post)
      end
    end
  end

  describe "get_children_categoriesアクション" do
  let!(:test_parent_category) { create(:parent_category) }
  let!(:children_categories) { create_list(:children_category, 3, ancestry: test_parent_category.id) }
    it "親カテゴリーを選択した際に子カテゴリーが動的に変化する" do
      login_user(user)
      get :get_children_categories, xhr: true, params: { parent_category_id: test_parent_category.id }
      expect(assigns(:children_categories)).to eq children_categories
      expect(response).to have_http_status "200"
    end
  end

  describe 'select_best_answerアクション' do
    let(:another_user) { create(:another_user) }
    let(:post) { create(:post, category_id: children_category.id, user_id: user.id) }
    let(:answer) { create(:answer, user_id: another_user.id, post_id: post.id)}
    it "ベストアンサーを選出しshow画面にリダイレクトする" do
      login_user(user)
      patch :select_best_answer, params: { id: post.id, post_form: { status: "解決済", best_answer_id: answer.id } }
      expect(response).to have_http_status "302"
      expect(response).to redirect_to questions_post_path(post)
      expect(post.reload.status).to eq "解決済"
      expect(post.reload.best_answer_id).to eq answer.id
    end
  end

end
