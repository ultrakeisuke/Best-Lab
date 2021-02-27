require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }

  it 'FactoryBotでuserデータが有効' do
    expect(user).to be_valid
  end
  it 'FactoryBotでanother_userデータが有効' do
    expect(another_user).to be_valid
  end

  it '名前が入力されなければ無効' do
    user.name = ''
    user.valid?
    expect(user.errors[:name]).to include('が入力されていません。')
  end

  it '51文字以上の名前が入力されれば無効' do
    user.name = 'a' * 51
    user.valid?
    expect(user.errors[:name]).to include('は50文字以下に設定してください。')
  end

  it '50文字以内の名前が入力されれば有効' do
    user.name = 'a' * 50
    user.valid?
    expect(user).to be_valid
  end

  describe 'self.guestメソッド' do
    it 'ゲストユーザーの情報を持つログインユーザーを生成' do
      user = User.guest
      expect(user.email).to eq 'guest@example.com'
    end
  end

  describe 'inactivate_accountメソッド' do
    it 'ユーザーを論理削除する' do
      user.inactivate_account
      expect(user.reload.name).to eq '退会済みユーザー'
      expect(user.reload.discarded?).to eq true
    end
  end

  describe 'inactivate_comments_and_noticesメソッド' do
    before do
      parent_category = create(:parent_category)
      children_category = create(:children_category, ancestry: parent_category.id)
      post = create(:post, user_id: user.id, category_id: children_category.id)
      answer = create(:answer, user_id: user.id, post_id: post.id)
      create(:reply, user_id: user.id, answer_id: answer.id, post_id: post.id)
      create(:question_entry, user_id: user.id, post_id: post.id)
    end
    it 'ユーザーのコメントと通知を削除する' do
      user.inactivate_comments_and_notices
      expect(Post.where(user_id: user)).to eq []
      expect(Answer.where(user_id: user)).to eq []
      expect(Reply.where(user_id: user)).to eq []
      expect(QuestionEntry.where(user_id: user)).to eq []
    end
  end

  describe 'profile_pictureメソッド' do
    context '画像が未設定だった場合' do
      it 'default.jpegを返す' do
        expect(user.profile_picture).to eq 'default.jpeg'
      end
    end
    context '画像が設定済みだった場合' do
      it '設定画像のurlを返す' do
        user.update(picture: File.open(File.join(Rails.root, 'spec/factories/images/rails.png')))
        expect(File.basename(user.profile_picture)).to eq 'rails.png'
      end
    end
  end
end
