require 'rails_helper'

RSpec.describe ProfileForm, type: :model do
  let(:user) { create(:user) }
  
  before :each do
    @profile_form = ProfileForm.new
    # user_idカラムはcontrollerでセットするので、@profile_form作成後に追加。
    @profile_form.user_id = user.id
  end


  it "プロフィール作成時にすべてのパラメータが空なら無効" do
    expect(@profile_form).not_to be_valid
    @profile_form.valid?
    expect(@profile_form.errors[:base]).to include "最低でも1つの項目を入力してください。"
  end

  it "所属(affiliation)カラムに未設定のパラメータが入ると無効" do
    @profile_form.affiliation = "hoge"
    expect(@profile_form).not_to be_valid
  end

  it "1つでも有効なパラメータが入力されていれば有効" do
    @profile_form.affiliation = "大学生"
    expect(@profile_form).to be_valid
  end

  it "1つでも有効なパラメータが入力されていればsaveメソッドは常にtrue" do
    @profile_form.affiliation = "大学生"
    expect(@profile_form.save).to be_truthy
  end

end
