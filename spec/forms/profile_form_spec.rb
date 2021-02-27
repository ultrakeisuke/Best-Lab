require 'rails_helper'

RSpec.describe ProfileForm, type: :model do
  let(:user) { create(:user) }
  let(:profile) { build(:profile_form, user_id: user.id, affiliation: '', school: '', faculty: '', department: '', laboratory: '', description: '') }

  it 'プロフィール作成時にすべてのパラメータが空なら無効' do
    expect(profile).not_to be_valid
    expect(profile.errors[:base]).to include '最低でも1つの項目を入力してください。'
  end

  it '所属(affiliation)カラムに未設定のパラメータが入ると無効' do
    profile.affiliation = 'hoge'
    expect(profile).not_to be_valid
  end

  it '1つでも有効なパラメータが入力されれば有効' do
    profile.affiliation = 'undergraduate'
    expect(profile).to be_valid
  end

  it '1つでも有効なパラメータが入力されていればsaveメソッドはtrueになる' do
    profile.affiliation = 'undergraduate'
    expect(profile.save).to be_truthy
  end
end
