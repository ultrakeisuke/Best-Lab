class QuestionEntry < ApplicationRecord
  belongs_to :user
  belongs_to :post

  # 回答、リプライしたエントリーを一覧表示する処理
  def self.sorted_comment_entries(user)
    post_ids = user.posts.ids
    # 自身の質問に関する情報は除き、新着通知が入った順にソート
    where(user_id: user).where.not(post_id: post_ids).order(updated_at: :desc)
  end

end
