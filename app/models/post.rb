class Post < ApplicationRecord
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :replies, dependent: :destroy
  has_many :question_entries, dependent: :destroy
  belongs_to :user
  belongs_to :category

  STATUS = { open: "受付中", closed: "解決済" }

  # 自己解決した場合の処理
  def solved_by_questioner
    best_answer = Answer.find_by(post_id: self, user_id: self.user_id)
    self.status = "closed"
    self.best_answer_id = best_answer.id
    self.save
  end

  # 英語名で保存された投稿状態(status)を日本語で表示 
  def translated_status
    STATUS[self.status.to_sym]
  end

end
