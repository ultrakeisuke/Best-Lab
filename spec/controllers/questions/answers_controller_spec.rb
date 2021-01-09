require 'rails_helper'

RSpec.describe Questions::AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:my_post) { create(:post, user_id: user.id, category_id: children_category.id) }
  let!(:another_post) { create(:post, user_id: another_user.id, category_id: children_category.id) }

  # createアクションに関するテスト
  describe '非同期通信によるcreateアクション' do
    context "フォーム入力が無効であった場合" do
      it "回答の作成に失敗する" do
        login_user(user)
        expect do
        post :create, xhr: true, params: { answer_form: { post_id: another_post.id, body: "" } }
        end.not_to change(Answer, :count)
        expect(response).to have_http_status "200"
        expect(response).to render_template "questions/answers/errors"
      end
    end
    context "フォーム入力が有効であった場合" do
      let(:answer_form) { build(:answer_form) }
      it "回答の作成に成功する" do
        login_user(user)
        expect do
        post :create, xhr: true, params: { answer_form: { post_id: another_post.id, body: answer_form.body } }
        end.to change(Answer, :count).by(1)
        expect(response).to have_http_status "200"
        expect(response).to render_template "questions/answers/create"
      end
    end
  end

  describe '同期通信によるcreateアクション' do
    context "フォーム入力が無効であった場合" do
      it "回答の作成に失敗する" do
        login_user(user)
        expect do
        post :create, params: { answer_form: { post_id: another_post.id, body: "" } }
        end.not_to change(Answer, :count)
        expect(response).to have_http_status "200"
        expect(response).to render_template "questions/posts/show"
      end
    end
    context "フォーム入力が有効であった場合" do
      let(:answer_form) { build(:answer_form) }
      it "回答の作成に成功する" do
        login_user(user)
        expect do
        post :create, params: { answer_form: { post_id: another_post.id, body: answer_form.body } }
        end.to change(Answer, :count).by(1)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to questions_post_path(another_post)
      end
    end
  end

  # updateアクションに関するテスト
  describe '非同期通信によるupdateアクション' do
    let!(:answer) { create(:answer, user_id: user.id, post_id: another_post.id) }
    context "フォーム入力が無効であった場合" do
      it "回答の編集に失敗する" do
        login_user(user)
        patch :update, xhr: true, params: { id: answer.id, answer_form: { id: answer.id,
                                                                          post_id: another_post.id,
                                                                          body: "" } }
        expect(answer.reload.body).not_to eq ""
        expect(answer.reload.body).to eq "answer"
        expect(response).to have_http_status "200"
        expect(response).to render_template "questions/answers/errors"
      end
    end
    context "フォーム入力が有効であった場合" do
      it "回答の編集に成功する" do
        login_user(user)
        patch :update, xhr: true, params: { id: answer.id, answer_form: { id: answer.id,
                                                                          post_id: another_post.id,
                                                                          body: "edited_answer" } }
        expect(answer.reload.body).to eq "edited_answer"
        expect(response).to have_http_status "200"
        expect(response).to render_template "questions/answers/update"
      end
    end
  end

  describe '同期通信によるupdateアクション' do
    let!(:answer) { create(:answer, user_id: user.id, post_id: another_post.id) }
    context "フォーム入力が無効であった場合" do
      it "回答の編集に失敗する" do
        login_user(user)
        patch :update, params: { id: answer.id, answer_form: { id: answer.id,
                                                               post_id: another_post.id,
                                                               body: "" } }
        expect(answer.reload.body).not_to eq ""
        expect(answer.reload.body).to eq "answer"
        expect(response).to have_http_status "200"
        expect(response).to render_template "questions/posts/show"
      end
    end
    context "フォーム入力が有効であった場合" do
      it "回答の編集に成功する" do
        login_user(user)
        patch :update, params: { id: answer.id, answer_form: { id: answer.id,
                                                               post_id: another_post.id,
                                                               body: "edited_answer" } }
        expect(answer.reload.body).to eq "edited_answer"
        expect(response).to have_http_status "302"
        expect(response).to redirect_to questions_post_path(answer.post_id)
      end
    end
  end

end
