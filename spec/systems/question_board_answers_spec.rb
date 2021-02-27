require 'rails_helper'

RSpec.describe '回答の作成と編集', type: :system do
  
  let!(:questioner) { create(:user, confirmed_at: Time.now) }
  let!(:answerer) { create(:another_user, confirmed_at: Time.now) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post) { create(:post, user_id: questioner.id, category_id: children_category.id) }

  it '回答の新規作成', js:true do
    login_as_user(answerer)
    visit questions_post_path(post)
    # エラーの表示確認
    find("#answer_form_body").set("")
    find("#answer_form").click_button
    expect(page).to have_content "コメントか画像を送信してください。"
    # 回答前の表示確認
    expect(page).to have_content "回答はまだついていません"
    expect(page).to have_content "あなたの回答"
    # 回答を送信
    find("#answer_form_body").set("answer")
    find("#answer_form").click_button
    # 回答後の表示確認
    expect(page).to have_content "回答1"
    expect(page).not_to have_content "あなたの回答"
    expect(page).not_to have_css("#answer_form")
  end

  it '自己解決した場合の表示確認', js: true do
    login_as_user(questioner)
    visit questions_post_path(post)
    # 回答前の表示確認
    expect(page).not_to have_content "ベストアンサー"
    expect(page).to have_content "回答はまだついていません"
    expect(page).to have_content "解決方法"
    # 回答を送信
    find("#answer_form_body").set("answer")
    find("#answer_form").click_button
    # 回答後の表示確認
    expect(page).to have_content "回答1"
    expect(page).to have_content "ベストアンサー"
    expect(page).not_to have_content "回答はまだついていません"
    expect(page).not_to have_content "解決方法"
    expect(page).not_to have_css("#answer_form")
  end

  it '回答の編集', js: true do
    answer = create(:answer, user_id: answerer.id, post_id: post.id, body: "answer")
    # 回答者としてログインし、質問詳細画面に移動
    login_as_user(answerer)
    visit questions_post_path(post)
    # 編集フォームが最初は非表示であることを確認
    expect(page).not_to have_css("#edit-answer-form-#{answer.id}")
    # 編集アイコンをクリックして編集フォームを表示
    find(".edit-answer-icon").click
    expect(page).to have_css("#edit-answer-form-#{answer.id}")
    # フォームに回答情報が既にセットされているか確認
    expect(find("#answer-form-#{answer.id}-textarea")).to have_content "answer"
    # キャンセルボタンを押すとフォームが非表示になることを確認
    click_button "キャンセル"
    expect(page).not_to have_css("#edit-answer-form-#{answer.id}")
    # 回答の編集に失敗
    find(".edit-answer-icon").click
    find("#answer-form-#{answer.id}-textarea").set("")
    click_button "回答を編集"
    expect(page).to have_content "コメントか画像を送信してください。"
    # 回答の編集に成功
    find("#answer-form-#{answer.id}-textarea").set("edited_answer")
    click_button "回答を編集"
    # 編集フォームが非表示になることを確認
    expect(page).not_to have_css("#edit-answer-form-#{answer.id}")
    # 編集内容が反映されたことを確認
    expect(page).to have_content "edited_answer"
  end

end
