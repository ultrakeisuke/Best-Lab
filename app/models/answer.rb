class Answer < ApplicationRecord
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :replies, dependent: :destroy
  belongs_to :user
  belongs_to :post

  # 質問に回答した際の通知処理
  def send_notice_to_questioner_or_answerers
    # 自己解決でない場合は質問者に通知を送信
    if self.user_id != self.post.user_id
      QuestionEntry.create(user_id: self.user_id, post_id: self.post_id) # 回答者用の通知レコードを作成
      questioner = QuestionEntry.find_by(user_id: self.post.user_id, post_id: self.post_id)
      questioner.update(notice: true) if questioner.notice == false
    else # 自己解決した場合は回答者に通知を送信
      self.post.send_notice_to_answerers
    end
  end

end
