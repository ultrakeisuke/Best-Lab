require 'rails_helper'

RSpec.describe Questions::RepliesController, type: :request do
  let(:user) { create(:user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:test_post) { create(:post, user_id: user.id, category_id: children_category.id) }
  let!(:answer) { create(:answer, user_id: user.id, post_id: test_post.id) }

  # createアクションに関するテスト
  describe '非同期通信によるcreateアクション' do
    context 'フォーム入力が無効であった場合' do
      it 'リプライの作成に失敗する' do
        login_user(user)
        expect do
          post questions_replies_path, xhr: true, params: { reply_form: { answer_id: answer.id,
                                                                          body: '' } }
        end.not_to change(Reply, :count)
        expect(response).to have_http_status '200'
        expect(response).to render_template 'questions/replies/create_errors'
      end
    end
    context 'フォーム入力が有効であった場合' do
      let(:reply_form) { build(:reply_form) }
      it 'リプライの作成に成功する' do
        login_user(user)
        expect do
          post questions_replies_path, xhr: true, params: { reply_form: { answer_id: answer.id,
                                                                          body: reply_form.body } }
        end.to change(Reply, :count).by(1)
        expect(response).to have_http_status '200'
        expect(response).to render_template 'questions/replies/create'
      end
    end
  end

  describe '同期通信によるcreateアクション' do
    context 'フォーム入力が無効であった場合' do
      it 'リプライの作成に失敗する' do
        login_user(user)
        expect do
          post questions_replies_path, params: { reply_form: { answer_id: answer.id,
                                                               body: '' } }
        end.not_to change(Reply, :count)
        expect(response).to have_http_status '200'
        expect(response).to render_template 'questions/posts/show'
      end
    end
    context 'フォーム入力が有効であった場合' do
      let(:reply_form) { build(:reply_form) }
      it 'リプライの作成に成功する' do
        login_user(user)
        expect do
          post questions_replies_path, params: { reply_form: { answer_id: answer.id,
                                                               body: reply_form.body } }
        end.to change(Reply, :count).by(1)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to questions_post_path(test_post)
      end
    end
  end

  # updateアクションに関するテスト
  describe '非同期通信によるupdateアクション' do
    let!(:reply) { create(:reply, user_id: user.id, answer_id: answer.id) }
    context 'フォーム入力が無効であった場合' do
      it 'リプライの編集に失敗する' do
        login_user(user)
        patch questions_reply_path(reply), xhr: true, params: { reply_form: { id: reply.id,
                                                                              answer_id: answer.id,
                                                                              body: '' } }
        expect(reply.reload.body).not_to eq ''
        expect(reply.reload.body).to eq 'reply'
        expect(response).to have_http_status '200'
        expect(response).to render_template 'questions/replies/update_errors'
      end
    end
    context '他人のリプライを編集しようとした場合' do
      let(:another_user) { create(:another_user) }
      let!(:another_reply) { create(:reply, user_id: another_user.id, answer_id: answer.id) }
      it 'リプライの編集に失敗し、ユーザー詳細画面にリダイレクトする' do
        login_user(user)
        patch questions_reply_path(another_reply), xhr: true, params: { reply_form: { id: another_reply.id,
                                                                                      answer_id: answer.id,
                                                                                      body: 'editied_reply' } }
        expect(response).to have_http_status '200'
        expect(response).to redirect_to users_basic_path(user)
      end
    end
    context 'フォーム入力が有効であった場合' do
      it 'リプライの編集に成功する' do
        login_user(user)
        patch questions_reply_path(reply), xhr: true, params: { reply_form: { id: reply.id,
                                                                              answer_id: answer.id,
                                                                              body: 'edited_reply' } }
        expect(reply.reload.body).to eq 'edited_reply'
        expect(response).to have_http_status '200'
        expect(response).to render_template 'questions/replies/update'
      end
    end
  end

  describe '同期通信によるupdateアクション' do
    let!(:reply) { create(:reply, user_id: user.id, answer_id: answer.id) }
    context 'フォーム入力が無効であった場合' do
      it 'リプライの編集に失敗する' do
        login_user(user)
        patch questions_reply_path(reply), params: { reply_form: { id: reply.id,
                                                                   answer_id: answer.id,
                                                                   post_id: test_post.id,
                                                                   body: '' } }
        expect(reply.reload.body).not_to eq ''
        expect(reply.reload.body).to eq 'reply'
        expect(response).to have_http_status '200'
        expect(response).to render_template 'questions/posts/show'
      end
    end
    context '他人のリプライを編集しようとした場合' do
      let(:another_user) { create(:another_user) }
      let!(:another_reply) { create(:reply, user_id: another_user.id, answer_id: answer.id) }
      it 'リプライの編集に失敗し、ユーザー詳細画面にリダイレクトする' do
        login_user(user)
        patch questions_reply_path(another_reply), params: { reply_form: { id: another_reply.id,
                                                                           answer_id: answer.id,
                                                                           body: 'editied_reply' } }
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_basic_path(user)
      end
    end
    context 'フォーム入力が有効であった場合' do
      it 'リプライの編集に成功する' do
        login_user(user)
        patch questions_reply_path(reply), params: { reply_form: { id: reply.id,
                                                                   answer_id: answer.id,
                                                                   post_id: test_post.id,
                                                                   body: 'edited_reply' } }
        expect(reply.reload.body).to eq 'edited_reply'
        expect(response).to have_http_status '302'
        expect(response).to redirect_to questions_post_path(reply.answer.post_id)
      end
    end
  end
end
