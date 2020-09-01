require 'rails_helper'

RSpec.feature 'ゲストログインとアカウント削除' do
  let(:guest_user) { create(:guest_user) }
  background do
    guest_user.confirm
  end

  scenario 'ゲストユーザーのアカウントを削除できない' do
    visit root_path
    click_link 'ゲストログイン(閲覧用)'
    expect(page).to have_content 'ゲストユーザーとしてログインしました。'

    click_link 'プロフィール'
    click_link 'プロフィールを編集'
    expect{ click_button 'アカウントの削除' }.not_to change(User, :count)
    
    expect(page).to have_current_path users_basic_path(guest_user)
    expect(page).to have_selector 'h3', text: guest_user.name
  end

end

