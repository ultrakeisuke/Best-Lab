require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:user) { create(:user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post) { create(:post, user_id: user.id, category_id: children_category.id) }
  let!(:answer_by_questioner) { create(:answer, user_id: user.id, post_id: post.id) }

  # 自己解決した場合の処理
  describe "solved_by_questionerメソッド" do
    it "投稿の受付状態を「closed」に変更し、ベストアンサーを決定する" do
      post.solved_by_questioner
      expect(post.reload.status).to eq "closed"
      expect(post.reload.best_answer_id).to eq answer_by_questioner.id
    end
  end

  # 英語名で保存された投稿状態(status)を日本語で表示 
  describe "translated_statusメソッド" do
    it "デフォルトの受付状態である「受付中」を表示する" do
      expect(post.translated_status).to eq "受付中"
    end
  end

  # 質問投稿者用に通知レコードを作成
  describe "create_entryメソッド" do
    it "質問とユーザーを紐づけたリストを作成し、通知カラムがfalseになっている" do
      post.create_entry
      question_entry = QuestionEntry.find_by(user_id: post.user_id, post_id: post)
      expect(question_entry.notice).to eq false
    end
  end

  # ベストアンサー決定時に回答者全員に通知を送信する
  describe "send_notice_to_answerers" do
    let(:user1) { create(:another_user) }
    let(:user2) { create(:guest_user) }
    let!(:questioner) { create(:question_entry, user_id: user.id, post_id: post.id) } 
    let!(:answerer1) { create(:question_entry, user_id: user1.id, post_id: post.id) }
    let!(:answerer2) { create(:question_entry, user_id: user2.id, post_id: post.id) }
    it "回答者の通知カラムがtrueを返す" do
      post.send_notice_to_answerers
      expect(questioner.reload.notice).to eq false # 質問者には通知が送信されない
      expect(answerer1.reload.notice).to eq true
      expect(answerer2.reload.notice).to eq true
    end
  end

  # 投稿詳細画面に入ると通知が外れる処理
  describe "remove_noticeメソッド" do
    let!(:entry) { create(:question_entry, user_id: user.id, post_id: post.id, notice: true) }
    it "通知カラムがfalseを返す" do
      post.remove_notice(user)
      expect(entry.reload.notice).to eq false
    end
  end

end
