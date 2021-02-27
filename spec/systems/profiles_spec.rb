require 'rails_helper'

RSpec.describe 'プロフィール作成', type: :system do
  let(:user) { create(:user, confirmed_at: Time.now) }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  it 'プロフィール作成に失敗する' do
    login_as_user(user)
    visit new_users_profile_path
    find('#profile_form_affiliation').find("option[value='unselected']").select_option
    find('#profile_form_school').set('')
    find('#profile_form_faculty').set('')
    find('#profile_form_department').set('')
    find('#profile_form_laboratory').set('')
    find('#profile_form_description').set('')
    click_button '保存'
    expect(page).to have_current_path users_profiles_path
  end

  it 'プロフィール作成に成功する' do
    login_as_user(user)
    visit new_users_profile_path
    find('#profile_form_affiliation').find("option[value='undergraduate']").select_option
    find('#profile_form_school').set('school')
    find('#profile_form_faculty').set('faculty')
    find('#profile_form_department').set('department')
    find('#profile_form_laboratory').set('laboratory')
    find('#profile_form_description').set('description')
    click_button '保存'
    expect(page).to have_current_path users_basic_path(user)
    expect(page).to have_content 'プロフィールを保存しました。'
  end
end

RSpec.describe 'プロフィール編集', type: :system do
  let(:user) { create(:user, confirmed_at: Time.now) }
  let(:profile) { create(:profile, user_id: user.id) }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  it 'プロフィール編集に失敗する' do
    login_as_user(user)
    visit edit_users_profile_path(profile)
    find('#profile_form_affiliation').find("option[value='unselected']").select_option
    find('#profile_form_school').set('')
    find('#profile_form_faculty').set('')
    find('#profile_form_department').set('')
    find('#profile_form_laboratory').set('')
    find('#profile_form_description').set('')
    click_button '保存'
    expect(page).to have_current_path users_profile_path(profile)
  end

  it 'プロフィール編集に成功する' do
    login_as_user(user)
    visit edit_users_profile_path(profile)
    find('#profile_form_affiliation').find("option[value='graduate']").select_option
    find('#profile_form_school').set('school')
    find('#profile_form_faculty').set('faculty')
    find('#profile_form_department').set('department')
    find('#profile_form_laboratory').set('laboratory')
    find('#profile_form_description').set('description')
    click_button '保存'
    expect(page).to have_current_path users_basic_path(user)
    expect(page).to have_content 'プロフィールを保存しました。'
  end
end
