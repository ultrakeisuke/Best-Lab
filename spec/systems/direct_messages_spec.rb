require 'rails_helper'

RSpec.describe 'ダイレクトメッセージの送信', js: true, type: :system do
  let!(:user) { create(:user, confirmed_at: Time.current) }
  let!(:partner) { create(:another_user, confirmed_at: Time.current) }
  let!(:guest) { create(:guest_user, confirmed_at: Time.current) }
  let!(:room) { create(:room) }
  let!(:user_entry) { create(:entry, user_id: user.id, room_id: room.id) }
  let!(:partner_entry) { create(:entry, user_id: partner.id, room_id: room.id) }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  it 'ダイレクトメッセージを送信する' do
    login_as_user(user)
    # partnerのユーザー詳細画面からメッセージルームに入る
    visit users_basic_path(partner)
    click_on 'メッセージルーム'
    # メッセージの未入力による送信失敗
    find('#message_form_body').set('')
    find('.post-field').click_button
    expect(page).to have_content 'メッセージには文字か画像が含まれるようにしてください。'
    # 画像枚数の超過による送信失敗
    attach_file '', [Rails.root.join('spec/factories/images/rails.png'),
                     Rails.root.join('spec/factories/images/default.jpeg'),
                     Rails.root.join('spec/factories/images/rails_welcome.png'),
                     Rails.root.join('spec/factories/images/discard.png'),
                     Rails.root.join('spec/factories/images/ruby-on-rails.jpg')], make_visible: true
    expect(page).to have_css('.too-many-files') # 画像枚数超過を知らせる警告を表示
    find('.post-field').click_button
    expect(page).to have_content '投稿できる画像は4枚までです。'
    # メッセージの送信に成功
    find('#message_form_body').set('message')
    attach_file '', Rails.root.join('spec/factories/images/rails.png'), make_visible: true
    find('.post-field').click_button
    # メッセージと画像が表示されていることを確認
    expect(page).to have_content 'message'
    expect(page).to have_selector("img[src$='rails.png']")
  end

  it 'メッセージ履歴の有無による画面表示の変化' do
    login_as_user(user)
    # メッセージルームがまだない相手の場合
    visit users_basic_path(guest)
    click_on 'メッセージを始める'
    # メッセージルームがすでにある相手の場合
    visit users_basic_path(partner)
    click_on 'メッセージルーム'
    expect(page).to have_current_path users_room_path(room)
  end
end

RSpec.describe 'ダイレクトメッセージの削除', type: :system do
  let!(:user) { create(:user, confirmed_at: Time.current) }
  let!(:partner) { create(:another_user, confirmed_at: Time.current) }
  let!(:room) { create(:room) }
  let!(:user_entry) { create(:entry, user_id: user.id, room_id: room.id) }
  let!(:partner_entry) { create(:entry, user_id: partner.id, room_id: room.id) }
  let!(:user_message) { create(:message, user_id: user.id, room_id: room.id, body: 'user_message') }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  it 'ダイレクトメッセージを削除する', js: true do
    login_as_user(user)
    visit users_room_path(room)
    expect(page).to have_content 'user_message'
    find("#message-id-#{user_message.id}").right_click # メッセージを右クリックすると、メニュー一覧に「削除」が表示される
    find("#message-id-#{user_message.id}__menu").click # 「削除」をクリック
    page.accept_confirm
    expect(page).not_to have_content 'user_message' # メッセージが削除される
  end
end
