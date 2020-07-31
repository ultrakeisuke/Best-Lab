require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }

  # FactoryBotが有効か検証
  it "has a valid factory of user" do
    expect(user).to be_valid
  end
  it "has a valid factory of another user" do 
    expect(another_user).to be_valid
  end

  # 名前が入力されなければ無効
  it "is invalid without name" do
    user.name = ""
    user.valid?
    expect(user.errors[:name]).to include("が入力されていません。")
  end
  # 名前が入力されれば有効
  it "is valid with name" do
    user.valid?
    expect(user).to be_valid
  end
  # プロフィールが201文字以上なら無効
  it "is invalid profile with too long characters" do
    user.profile = "a"*201
    user.valid?
    expect(user).not_to be_valid
  end
  # プロフィールが200文字以内なら有効
  it "is valid profile with less than 200 characters" do
    user.profile = "a"*200
    user.valid?
    expect(user).to be_valid
  end
  # パスワードが空なら無効
  it "is invalid without password" do
    user.password = ""
    user.valid?
    expect(user.errors[:password]).to include "が入力されていません。"
  end
  # 確認用パスワードが空なら無効
  it "is invalid without password_confirmation" do
    user.password_confirmation = ""
    user.valid?
    expect(user.errors[:password_confirmation]).to include "が正しくありません。"
  end
  # パスワードが6文字未満なら無効
  it "is invalid password less than 5 characters" do
    user.password = "a"*5
    user.password_confirmation = "a"*5
    user.valid?
    expect(user.errors[:password]).to include "は6文字以上に設定してください。"
  end
  # パスワードが129文字以上なら無効
  it "is invalid password more than 129 characters" do
    user.password = "a"*129
    user.password_confirmation = "a"*129
    user.valid?
    expect(user.errors[:password]).to include "は128文字以下に設定してください。"
  end

end
