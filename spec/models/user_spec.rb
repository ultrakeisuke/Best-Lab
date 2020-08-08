require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }

  it "FactoryBotでuserデータが有効" do
    expect(user).to be_valid
  end
  it "FactoryBotでanother_userデータが有効" do 
    expect(another_user).to be_valid
  end

  it "名前が入力されなければ無効" do
    user.name = ""
    user.valid?
    expect(user.errors[:name]).to include("が入力されていません。")
  end

  it "51文字以上の名前が入力されれば無効" do
    user.name = "a"*51
    user.valid?
    expect(user.errors[:name]).to include("は50文字以下に設定してください。")
  end

  it "50文字以内の名前が入力されれば有効" do
    user.name = "a"*50
    user.valid?
    expect(user).to be_valid
  end

  it "プロフィールが201文字以上なら無効" do
    user.profile = "a"*201
    user.valid?
    expect(user).not_to be_valid
  end

  it "プロフィールが200文字以内なら有効" do
    user.profile = "a"*200
    user.valid?
    expect(user).to be_valid
  end



end
