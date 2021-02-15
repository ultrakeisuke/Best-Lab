require 'rails_helper'

RSpec.describe QuestionEntry, type: :model do

  before do
    @user1 = create(:user)
    @user2 = create(:another_user)
    @user3 = create(:guest_user)

    parent_category = create(:parent_category)
    children_category = create(:children_category, ancestry: parent_category.id)
    
    # post1にはuser3が作成した回答が1つ含まれる
    post1 = create(:post, user_id: @user1.id, category_id: children_category.id)
    answer1 = create(:answer, user_id: @user3.id, post_id: post1.id)
    @entry1 = create(:question_entry, user_id: @user3.id, post_id: post1.id, updated_at: Time.now + 1.second)

    # post2にはuser3が作成したリプライが1つ含まれる
    post2 = create(:post, user_id: @user2.id, category_id: children_category.id)
    answer2 = create(:answer, user_id: @user2.id, post_id: post2.id)
    reply2 = create(:reply, user_id: @user3.id, post_id: post2.id, answer_id: answer2.id)
    @entry2 = create(:question_entry, user_id: @user3.id, post_id: post2.id)

    # post3はuser3が作成
    post3 = create(:post, user_id: @user3.id, category_id: children_category.id)
    @entry3 = create(:question_entry, user_id: @user3.id, post_id: post3.id)
  end

  describe "self.sorted_comment_entriesメソッド" do
    it "@user3が回答、リプライしたエントリーを一覧表示する" do
      comment_lists = QuestionEntry.sorted_comment_entries(@user3)
      expect(comment_lists).to eq [@entry1, @entry2] # post3はuser3が作成した質問なので@entry3は一覧に加えない
    end
  end

end