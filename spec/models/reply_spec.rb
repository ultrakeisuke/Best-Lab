require 'rails_helper'

RSpec.describe Reply, type: :model do
  let(:user1) { create(:user) }
  let(:user2) { create(:another_user) }
  let(:user3) { create(:guest_user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post) { create(:post, user_id: user3.id, category_id: children_category.id) }
  let!(:questioner) { create(:question_entry, user_id: user3.id, post_id: post.id) } # 質問者用の通知レコード

  describe "send_notice_to_questioner_and_answererメソッド" do
    context "リプライした人が質問投稿者であった場合" do
      it "回答者にのみ通知を送信する" do
        answer = create(:answer, user_id: user1.id, post_id: post.id) # user1が回答を作成
        answerer = create(:question_entry, user_id: user1.id, post_id: post.id) # 回答者の通知レコードを作成
        reply = create(:reply, user_id: user3.id, post_id: post.id, answer_id: answer.id) # 返信者は質問者と同じuser3
        reply.send_notice_to_questioner_and_answerer
        expect(questioner.reload.notice).to eq false
        expect(answerer.reload.notice).to eq true
      end
    end
    context "リプライした人が回答者であった場合" do
      it "質問者投稿者にのみ通知を送信する" do
        answer = create(:answer, user_id: user1.id, post_id: post.id) # user1が回答を作成
        answerer = create(:question_entry, user_id: user1.id, post_id: post.id) # 回答者の通知レコードを作成
        reply = create(:reply, user_id: user1.id, post_id: post.id, answer_id: answer.id) # 返信者は回答者と同じuser1
        reply.send_notice_to_questioner_and_answerer
        expect(questioner.reload.notice).to eq true
        expect(answerer.reload.notice).to eq false
      end
    end
    context "リプライした人が質問投稿者でも回答者でもない場合" do
      it "質問投稿者と回答者の両方に通知を送信する" do
        answer = create(:answer, user_id: user1.id, post_id: post.id) # user1が回答を作成
        answerer = create(:question_entry, user_id: user1.id, post_id: post.id) # 回答者の通知レコードを作成
        reply = create(:reply, user_id: user2.id, post_id: post.id, answer_id: answer.id) # 返信者は質問者でも回答者でもないuser2
        reply.send_notice_to_questioner_and_answerer
        expect(questioner.reload.notice).to eq true
        expect(answerer.reload.notice).to eq true
      end
    end
  end

  describe "send_notice_to_commenterメソッド" do
    it "回答に紐づく返信者に通知を送信する" do
      answer = create(:answer, user_id: user1.id, post_id: post.id) # user1が回答を作成
      answerer = create(:question_entry, user_id: user1.id, post_id: post.id) # 回答者の通知レコードを作成
      reply1 = create(:reply, user_id: user1.id, post_id: post.id, answer_id: answer.id)
      reply2 = create(:reply, user_id: user2.id, post_id: post.id, answer_id: answer.id)
      replier = create(:question_entry, user_id: user2.id, post_id: post.id) # 返信者用の通知レコードを作成
      reply3 = create(:reply, user_id: user3.id, post_id: post.id, answer_id: answer.id)
      reply3.send_notice_to_commenter # user3が返信した場合
      # 他の返信者(user1,user2)に通知が送信される
      expect(replier.reload.notice).to eq true # user2に通知を送信する
      expect(questioner.reload.notice).to eq false # 返信者(user3)は質問者と同じなので通知は送信されない
      expect(answerer.reload.notice).to eq true # 回答者(user1)は返信者と異なるので通知が送信される
    end
  end

end
