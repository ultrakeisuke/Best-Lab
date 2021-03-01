require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:user) { create(:user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:test_post) { create(:post, user_id: user.id, category_id: children_category.id) }

  it 'コメントも画像もない場合は無効' do
    answer = build(:answer_form, user_id: user.id, post_id: test_post.id, body: '')
    answer.pictures = []
    expect(answer).not_to be_valid
    expect(answer.errors[:base]).to include('コメントか画像を送信してください。')
  end

  it '5枚以上の画像を投稿した場合は無効' do
    answer = build(:answer_form, user_id: user.id, post_id: test_post.id, body: '')
    pictures = build_list(:picture, 5)
    answer.pictures = pictures
    expect(answer).not_to be_valid
    expect(answer.errors[:base]).to include('投稿できる画像は4枚までです。')
  end

  it '4枚以下の画像を投稿した場合は有効' do
    answer = build(:answer_form, user_id: user.id, post_id: test_post.id, body: '')
    pictures = build_list(:picture, 4)
    answer.pictures = pictures
    expect(answer).to be_valid
  end

  it 'コメントと4枚以下の画像を投稿した場合は有効' do
    answer = build(:answer_form, user_id: user.id, post_id: test_post.id)
    pictures = build_list(:picture, 4)
    answer.pictures = pictures
    expect(answer).to be_valid
  end
end
