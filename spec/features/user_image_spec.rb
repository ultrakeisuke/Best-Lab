require 'rails_helper'

RSpec.feature 'プロフィール画像のアップロード' do  
  let(:user) { create(:user) }

  before do
    user.confirm
  end

  scenario '画像アップロード' do
    login_as_user(user)

    # ユーザーのプロフィールの編集
    click_link 'プロフィール'
    click_link 'プロフィールを編集'
    attach_file 'プロフィール画像', "#{Rails.root}/spec/factories/images/rails.png"
    click_button '保存'
    expect(page).to have_selector("img[src$='rails.png']")
  end
end