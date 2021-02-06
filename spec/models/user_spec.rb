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

  describe "self.guestメソッド" do
    it "ゲストユーザーの情報を持つログインユーザーを生成" do
      user = User.guest
      expect(user.email).to eq "guest@example.com"
    end
  end

  describe "inactivate_accountメソッド" do
    it "ユーザーを論理削除する" do
      user.inactivate_account
      expect(user.reload.name).to eq "退会済みユーザー"
      expect(user.reload.picture.file.basename).to eq "discard"
    end
  end

end
