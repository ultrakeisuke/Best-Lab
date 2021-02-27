require 'rails_helper'

RSpec.describe 'リプライの作成と編集', type: :system do
  let!(:questioner) { create(:user, confirmed_at: Time.now) }
  let!(:answerer) { create(:another_user, confirmed_at: Time.now) }
  let!(:replier) { create(:guest_user, confirmed_at: Time.now) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post) { create(:post, user_id: questioner.id, category_id: children_category.id) }
  let!(:answer) { create(:answer, user_id: answerer.id, post_id: post.id) }

  before do
    create(:question_entry, user_id: questioner.id, post_id: post.id)
    create(:question_entry, user_id: answerer.id, post_id: post.id)
  end

  it 'リプライの新規作成', js: true do
    # リプライヤーとしてログイン
    login_as_user(replier)
    visit questions_post_path(post)
    # エラーの表示確認
    find("#reply-textarea-#{answer.id}").set('')
    click_button 'リプライを送信'
    expect(page).to have_content 'コメントか画像を送信してください。'
    # リプライを送信
    find("#reply-textarea-#{answer.id}").set('new_reply')
    click_button 'リプライを送信'
    # リプライ後の表示確認
    expect(page).to have_content 'new_reply'
  end

  it 'リプライの編集', js: true do
    reply = create(:reply, user_id: replier.id, post_id: post.id, answer_id: answer.id, body: 'reply')
    another_reply = create(:reply, user_id: replier.id, post_id: post.id, answer_id: answer.id, body: 'another_reply')
    # 返信者としてログインし、質問詳細画面に移動
    login_as_user(replier)
    visit questions_post_path(post)
    # 編集フォームが最初は非表示であることを確認
    expect(page).not_to have_css("#edit-reply-form-#{reply.id}")
    # 編集アイコンをクリックして編集フォームを表示
    find("#edit-reply-icon-#{reply.id}").click
    expect(page).to have_css("#edit-reply-form-#{reply.id}")
    expect(page).not_to have_css("#edit-reply-form-#{another_reply.id}") # 他のリプライは反応しないことを確認
    # フォームにリプライ情報が既にセットされているか確認
    expect(find("#reply-#{reply.id}-textarea")).to have_content 'reply'
    # キャンセルボタンを押すとフォームが非表示になることを確認
    find("#edit-reply-cancel-#{reply.id}").click
    expect(page).not_to have_css("#edit-reply-form-#{reply.id}")
    # リプライの編集に失敗
    find("#edit-reply-icon-#{reply.id}").click
    find("#reply-#{reply.id}-textarea").set('')
    click_button 'リプライを編集'
    expect(page).to have_content 'コメントか画像を送信してください。'
    # リプライの編集に成功
    find("#reply-#{reply.id}-textarea").set('edited_reply')
    click_button 'リプライを編集'
    # 編集フォームが非表示になることを確認
    expect(page).not_to have_css("#edit-reply-form-#{answer.id}")
    # 編集内容が反映されたことを確認
    expect(page).to have_content 'edited_reply'
  end
end
