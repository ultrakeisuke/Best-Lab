class Post < ApplicationRecord
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :replies, dependent: :destroy
  belongs_to :user
  belongs_to :category

  # 自己解決した場合の処理
  def solved_by_questioner
    best_answer = Answer.find_by(post_id: self, user_id: self.user_id)
    self.status = "解決済"
    self.best_answer_id = best_answer.id
    self.save
  end
end
