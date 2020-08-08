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

  it "パスワードが空なら無効" do
    user.password = ""
    user.valid?
    expect(user.errors[:password]).to include "が入力されていません。"
  end

  it "確認用パスワードが空なら無効" do
    user.password_confirmation = ""
    user.valid?
    expect(user.errors[:password_confirmation]).to include "が正しくありません。"
  end

  it "パスワードが6文字未満なら無効" do
    user.password = "a"*5
    user.password_confirmation = "a"*5
    user.valid?
    expect(user.errors[:password]).to include "は6文字以上に設定してください。"
  end

  it "パスワードが129文字以上なら無効" do
    user.password = "a"*129
    user.password_confirmation = "a"*129
    user.valid?
    expect(user.errors[:password]).to include "は128文字以下に設定してください。"
  end

end
