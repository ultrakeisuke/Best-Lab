require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }

  it '設定した値以外をstatusカラムに入力した場合は無効' do
    post = build(:post_form, title: 'title', content: 'content', status: '', category_id: children_category.id, user_id: user.id)
    post.pictures = []
    expect(post).not_to be_valid
  end

  it '設定した値をstatusカラムに入力した場合は有効' do
    post1 = build(:post_form, title: 'title', content: 'content', status: 'open', category_id: children_category.id, user_id: user.id)
    post2 = build(:post_form, title: 'title', content: 'content', status: 'closed', category_id: children_category.id, user_id: user.id)
    post1.pictures = []
    post2.pictures = []
    expect(post1).to be_valid
    expect(post2).to be_valid
  end

  it '画像を5枚以上添付した場合は無効' do
    post = build(:post_form, title: 'title', content: 'content', status: 'open', category_id: children_category.id, user_id: user.id)
    pictures = build_list(:picture, 5)
    post.pictures = pictures
    expect(post).not_to be_valid
    expect(post.errors[:base]).to include('投稿できる画像は4枚までです。')
  end

  it '画像を4枚添付した場合は有効' do
    post = build(:post_form, title: 'title', content: 'content', status: 'open', category_id: children_category.id, user_id: user.id)
    pictures = build_list(:picture, 4)
    post.pictures = pictures
    expect(post).to be_valid
  end
end
