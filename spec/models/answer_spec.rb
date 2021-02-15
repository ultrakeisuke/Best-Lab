require 'rails_helper'

RSpec.describe Answer, type: :model do
  let(:answerer1) { create(:user) }
  let(:answerer2) { create(:guest_user) }
  let(:questioner) { create(:another_user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post) { create(:post, user_id: questioner.id, category_id: children_category.id) }

  # 回答者が質問者に通知を送信する処理
  describe "send_notice_to_questioner_or_answerersメソッド" do
    context "自己解決でない場合" do
      it "質問者の通知カラムがtrueを返す" do
        create(:question_entry, user_id: questioner.id, post_id: post.id) # 質問者の通知レコードを作成
        answer = create(:answer, user_id: answerer1.id, post_id: post.id) # 質問者以外の人が回答を作成
        answer.send_notice_to_questioner_or_answerers
        question_entry = QuestionEntry.find_by(user_id: questioner, post_id: post)
        expect(question_entry.notice).to eq true
      end
    end
    context "自己解決の場合" do
      it "回答者の通知カラムがtrueを返す" do
        answer_entry1 = create(:question_entry, user_id: answerer1.id, post_id: post.id) # 回答者の通知レコードを作成
        answer_entry2 = create(:question_entry, user_id: answerer2.id, post_id: post.id)
        answer = create(:answer, user_id: questioner.id, post_id: post.id) # 質問者が回答を作成
        answer.send_notice_to_questioner_or_answerers
        expect(answer_entry1.reload.notice).to eq true
        expect(answer_entry2.reload.notice).to eq true
      end
    end
  end

end
