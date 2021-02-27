require 'rails_helper'

RSpec.describe Reply, type: :model do
  let(:user) { create(:user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:test_post) { create(:post, user_id: user.id, category_id: children_category.id) }
  let!(:answer) { create(:answer, user_id: user.id, post_id: test_post.id) }

  it 'コメントも画像もない場合は無効' do
    reply = build(:reply_form, user_id: user.id, post_id: test_post.id, answer_id: answer.id, body: '')
    reply.pictures = []
    expect(reply).not_to be_valid
    expect(reply.errors[:base]).to include('コメントか画像を送信してください。')
  end

  it '5枚以上の画像を投稿した場合は無効' do
    reply = build(:reply_form, user_id: user.id, post_id: test_post.id, answer_id: answer.id, body: '')
    pictures = build_list(:picture, 5)
    reply.pictures = pictures
    expect(reply).not_to be_valid
    expect(reply.errors[:base]).to include('投稿できる画像は4枚までです。')
  end

  it '4枚以下の画像を投稿した場合は有効' do
    reply = build(:reply_form, user_id: user.id, post_id: test_post.id, body: '')
    pictures = build_list(:picture, 4)
    reply.pictures = pictures
    expect(reply).to be_valid
  end

  it 'コメントと4枚以下の画像を投稿した場合は有効' do
    reply = build(:reply_form, user_id: user.id, post_id: test_post.id)
    pictures = build_list(:picture, 4)
    reply.pictures = pictures
    expect(reply).to be_valid
  end
end
