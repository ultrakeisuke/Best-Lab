require 'rails_helper'

RSpec.describe 'ダイレクトメッセージの通知', type: :system do
  let!(:user) { create(:user, confirmed_at: Time.current) }
  let!(:partner) { create(:another_user, confirmed_at: Time.current) }
  let!(:room) { create(:room) }
  let!(:user_entry) { create(:entry, user_id: user.id, room_id: room.id) }
  let!(:partner_entry) { create(:entry, user_id: partner.id, room_id: room.id) }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  it 'メッセージの送信を相手に通知する' do
    # メッセージ送信者としてログイン
    login_as_user(user)
    visit users_room_path(room)
    find('#message_form_body').set('new_message') # メッセージを送信
    find('.post-field').click_button
    click_button 'ログアウト'
    # メッセージ受信者としてログイン
    login_as_user(partner)
    visit users_rooms_path # メッセージ相手を一覧表示する画面に移動
    expect(page).to have_css('.has-notice') # 通知の存在を確認
    click_link user.name.to_s # userとのメッセージルームに入る
    visit users_rooms_path # 再度一覧画面に移動
    expect(page).not_to have_css('.has-notice') # 通知の消失を確認
  end
end

RSpec.describe '質問掲示板における、質問者からの通知', type: :system do
  let!(:questioner) { create(:user, confirmed_at: Time.current) }
  let!(:answerer1) { create(:another_user, confirmed_at: Time.current) }
  let!(:answerer2) { create(:guest_user, confirmed_at: Time.current) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post) { create(:post, user_id: questioner.id, category_id: children_category.id) }
  let!(:answer1) { create(:answer, user_id: answerer1.id, post_id: post.id) }
  let!(:answer2) { create(:answer, user_id: answerer2.id, post_id: post.id) }

  before do
    # 質問者と回答者用の通知レコードを作成
    create(:question_entry, user_id: questioner.id, post_id: post.id)
    create(:question_entry, user_id: answerer1.id, post_id: post.id)
    create(:question_entry, user_id: answerer2.id, post_id: post.id)
  end

  it 'ベストアンサーを決定した場合は、回答者全員に通知を送信', js: true do
    # 質問者としてログインし、ベストアンサーを決定
    login_as_user(questioner)
    visit questions_post_path(post)
    find("#best-answer-#{answer1.id}").click_button # ベストアンサーボタンをクリック
    page.accept_confirm
    expect(page).to have_content 'ベストアンサーが決定しました！'
    expect(page).to have_css('.answer-best') # 選出された回答に「ベストアンサー」の表記が入る
    click_on 'ログアウト'
    # 回答者1(answerer1)としてログインし、通知を確認
    login_as_user(answerer1)
    visit questions_answers_path # 回答一覧ページに移動
    expect(page).to have_css('.has-notice')
    # 通知の消失処理も確認
    click_link post.title.to_s # 投稿詳細ページに移動
    visit questions_answers_path # 再度一覧ページに移動
    expect(page).not_to have_css('.has-notice')
    click_on 'ログアウト'
    # 回答者2(answerer2)としてログインし、通知を確認
    login_as_user(answerer2)
    visit questions_answers_path
    expect(page).to have_css('.has-notice')
  end

  it '自己解決した場合は、回答者全員に通知を送信', js: true do
    # 質問者としてログインし、回答を送信
    login_as_user(questioner)
    visit questions_post_path(post)
    find('#answer_form_body').set('solved_by_questioner')
    find('#answer_form').click_button
    expect(page).to have_css('.answer-best') # 選出された回答に「ベストアンサー」の表記が入る
    click_button 'ログアウト'
    # 回答者1(answerer1)としてログインし、通知を確認
    login_as_user(answerer1)
    visit questions_answers_path # 回答一覧ページに移動
    expect(page).to have_css('.has-notice')
    click_on 'ログアウト'
    # 回答者2(answerer2)としてログインし、通知を確認
    login_as_user(answerer2)
    visit questions_answers_path
    expect(page).to have_css('.has-notice')
  end
end

RSpec.describe '質問掲示板における、回答者からの通知', type: :system do
  let!(:questioner) { create(:user, confirmed_at: Time.current) }
  let!(:answerer) { create(:another_user, confirmed_at: Time.current) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post) { create(:post, user_id: questioner.id, category_id: children_category.id) }

  before do
    # 質問者の通知用レコードを作成
    create(:question_entry, user_id: questioner.id, post_id: post.id)
  end

  it '質問者に通知を送信' do
    # 回答者としてログインし、回答を送信
    login_as_user(answerer)
    visit questions_post_path(post)
    find('#answer_form_body').set('answer')
    find('#answer_form').click_button
    click_button 'ログアウト'
    # 質問者としてログイン
    login_as_user(questioner)
    visit users_basic_path(questioner)
    expect(page).to have_content post.title.to_s
    expect(page).to have_css('.has-notice') # 通知を確認
  end
end

RSpec.describe '質問掲示板における、返信者(リプライヤー)からの通知', type: :system do
  let!(:questioner) { create(:another_user, confirmed_at: Time.current) }
  let!(:answerer) { create(:guest_user, confirmed_at: Time.current) }
  let!(:replier) { create(:user, confirmed_at: Time.current) }
  let!(:repliers) { create_list(:test_users, 2, confirmed_at: Time.current) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post) { create(:post, user_id: questioner.id, category_id: children_category.id) }
  let!(:answer) { create(:answer, user_id: answerer.id, post_id: post.id) }

  before do
    # 通知用レコードを作成
    create(:question_entry, user_id: questioner.id, post_id: post.id)
    create(:question_entry, user_id: answerer.id, post_id: post.id)
    create(:question_entry, user_id: repliers[0].id, post_id: post.id)
    create(:question_entry, user_id: repliers[1].id, post_id: post.id)
  end

  it '質問者と回答者、回答に紐づくリプライヤーに通知を送信' do
    # 返信者(replier)としてログインし、回答を送信
    login_as_user(replier)
    visit questions_post_path(post)
    find("#reply-textarea-#{answer.id}").set('reply')
    find("#display-#{answer.id}").click_button
    click_button 'ログアウト'
    # 質問者としてログイン
    login_as_user(questioner)
    visit users_basic_path(questioner)
    expect(page).to have_css('.has-notice') # 通知を確認
    click_button 'ログアウト'
    # 回答者としてログイン
    login_as_user(answerer)
    visit questions_answers_path
    expect(page).to have_css('.has-notice') # 通知を確認
    click_button 'ログアウト'
    # 回答に紐づかない返信者(リプライヤー)には通知されないことを確認
    login_as_user(repliers[0])
    visit questions_answers_path
    expect(page).not_to have_css('.has-notice')
    click_button 'ログアウト'
    login_as_user(repliers[1])
    visit questions_answers_path
    expect(page).not_to have_css('.has-notice')
  end
end
