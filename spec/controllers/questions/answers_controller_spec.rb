require 'rails_helper'

RSpec.describe Questions::AnswersController, type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:my_post) { create(:post, user_id: user.id, category_id: children_category.id) }
  let!(:another_post) { create(:post, user_id: another_user.id, category_id: children_category.id) }

  # indexアクションに関するテスト
  describe 'indexアクション' do
    it '正常なレスポンスとテンプレートを返す' do
      login_user(user)
      get questions_answers_path
      expect(response).to have_http_status '200'
    end
  end

  # createアクションに関するテスト
  describe '非同期通信によるcreateアクション' do
    context 'フォーム入力が無効であった場合' do
      it '回答の作成に失敗する' do
        login_user(user)
        expect do
          post questions_answers_path, xhr: true, params: { answer_form: { post_id: another_post.id, body: '' } }
        end.not_to change(Answer, :count)
        expect(response).to have_http_status '200'
      end
    end
    context 'フォーム入力が有効であった場合' do
      let(:answer_form) { build(:answer_form) }
      let!(:questioner) { create(:question_notice, user_id: another_user.id, post_id: another_post.id) }
      it '回答の作成に成功する' do
        login_user(user)
        expect do
          post questions_answers_path, xhr: true, params: { answer_form: { post_id: another_post.id, body: answer_form.body } }
        end.to change(Answer, :count).by(1)
        expect(response).to have_http_status '200'
      end
    end
    context 'フォーム入力が有効かつ添付画像がある場合' do
      let(:answer_form) { build(:answer_form) }
      let!(:questioner) { create(:question_notice, user_id: another_user.id, post_id: another_post.id) }
      it '回答の作成に成功する' do
        login_user(user)
        expect do
          post questions_answers_path, xhr: true, params: { answer_form: { post_id: another_post.id,
                                                                           body: answer_form.body,
                                                                           pictures_attributes: [picture: Rack::Test::UploadedFile.new(Rails.root.join('spec/factories/images/rails.png'))] } }
        end.to change(Answer, :count).by(1)
        expect(response).to have_http_status '200'
      end
    end
    context 'フォーム入力が有効、かつ自己解決した場合' do
      let(:answer_form) { build(:answer_form) }
      it '回答の作成に成功し、質問を「解決済」に変更する' do
        login_user(user)
        expect do
          post questions_answers_path, xhr: true, params: { answer_form: { post_id: my_post.id, body: answer_form.body } }
        end.to change(Answer, :count).by(1)
        # 質問の状態を「解決済」にし、best_answer_idに回答のidを追加しているか検証
        expect(my_post.reload.status).to eq 'closed'
        best_answer = Answer.find_by(post_id: my_post, user_id: user)
        expect(my_post.reload.best_answer_id).to eq best_answer.id
        expect(response).to have_http_status '200'
      end
    end
  end

  describe '同期通信によるcreateアクション' do
    context 'フォーム入力が無効であった場合' do
      it '回答の作成に失敗する' do
        login_user(user)
        expect do
          post questions_answers_path, params: { answer_form: { post_id: another_post.id, body: '' } }
        end.not_to change(Answer, :count)
        expect(response).to have_http_status '200'
      end
    end
    context 'フォーム入力が有効であった場合' do
      let(:answer_form) { build(:answer_form) }
      let!(:questioner) { create(:question_notice, user_id: another_user.id, post_id: another_post.id) }
      it '回答の作成に成功する' do
        login_user(user)
        expect do
          post questions_answers_path, params: { answer_form: { post_id: another_post.id, body: answer_form.body } }
        end.to change(Answer, :count).by(1)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to questions_post_path(another_post)
      end
    end
    context 'フォーム入力が有効、かつ自己解決した場合' do
      let(:answer_form) { build(:answer_form) }
      it '回答の作成に成功し、質問を「解決済」に変更する' do
        login_user(user)
        expect do
          post questions_answers_path, params: { answer_form: { post_id: my_post.id, body: answer_form.body } }
        end.to change(Answer, :count).by(1)
        # 質問の状態を「解決済」にし、best_answer_idに回答のidを追加しているか検証
        expect(my_post.reload.status).to eq 'closed'
        best_answer = Answer.find_by(post_id: my_post, user_id: user)
        expect(my_post.reload.best_answer_id).to eq best_answer.id
        expect(response).to have_http_status '302'
        expect(response).to redirect_to questions_post_path(my_post)
      end
    end
  end

  # updateアクションに関するテスト
  describe '非同期通信によるupdateアクション' do
    let!(:answer) { create(:answer, user_id: user.id, post_id: another_post.id) }
    context 'フォーム入力が無効であった場合' do
      it '回答の編集に失敗する' do
        login_user(user)
        patch questions_answer_path(answer), xhr: true, params: { answer_form: { id: answer.id,
                                                                                 post_id: another_post.id,
                                                                                 body: '' } }
        expect(answer.reload.body).not_to eq ''
        expect(answer.reload.body).to eq 'answer'
        expect(response).to have_http_status '200'
      end
    end
    context '他人の回答を編集しようとした場合' do
      let!(:another_answer) { create(:answer, user_id: another_user.id, post_id: another_post.id) }
      it '回答の編集に失敗し、ユーザー詳細画面にリダイレクトする' do
        login_user(user)
        patch questions_answer_path(another_answer), xhr: true, params: { answer_form: { id: another_answer.id,
                                                                                         post_id: another_post.id,
                                                                                         body: 'edited_answer' } }
        expect(response).to have_http_status '200'
        expect(response).to redirect_to users_basic_path(user)
      end
    end
    context 'フォーム入力が有効であった場合' do
      it '回答の編集に成功する' do
        login_user(user)
        patch questions_answer_path(answer), xhr: true, params: { answer_form: { id: answer.id,
                                                                                 post_id: another_post.id,
                                                                                 body: 'edited_answer' } }
        expect(answer.reload.body).to eq 'edited_answer'
        expect(response).to have_http_status '200'
      end
    end
  end

  describe '同期通信によるupdateアクション' do
    let!(:answer) { create(:answer, user_id: user.id, post_id: another_post.id) }
    context 'フォーム入力が無効であった場合' do
      it '回答の編集に失敗する' do
        login_user(user)
        patch questions_answer_path(answer), params: { answer_form: { id: answer.id,
                                                                      post_id: another_post.id,
                                                                      body: '' } }
        expect(answer.reload.body).not_to eq ''
        expect(answer.reload.body).to eq 'answer'
        expect(response).to have_http_status '200'
      end
    end
    context '他人の回答を編集しようとした場合' do
      let!(:another_answer) { create(:answer, user_id: another_user.id, post_id: another_post.id) }
      it '回答の編集に失敗し、ユーザー詳細画面にリダイレクトする' do
        login_user(user)
        patch questions_answer_path(another_answer), params: { answer_form: { id: another_answer.id,
                                                                              post_id: another_post.id,
                                                                              body: 'edited_answer' } }
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_basic_path(user)
      end
    end
    context 'フォーム入力が有効であった場合' do
      it '回答の編集に成功する' do
        login_user(user)
        patch questions_answer_path(answer), params: { answer_form: { id: answer.id,
                                                                      post_id: another_post.id,
                                                                      body: 'edited_answer' } }
        expect(answer.reload.body).to eq 'edited_answer'
        expect(response).to have_http_status '302'
        expect(response).to redirect_to questions_post_path(answer.post_id)
      end
    end
  end
end
