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

end
