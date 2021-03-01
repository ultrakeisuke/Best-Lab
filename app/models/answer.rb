class Answer < ApplicationRecord
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :replies, dependent: :destroy
  belongs_to :user
  belongs_to :post

  # 質問に回答した際の通知処理
  def send_notice_to_questioner_or_answerers
    # 自己解決でない場合は質問者に通知を送信
    if user_id != post.user_id
      questioner = QuestionEntry.find_or_create_by(user_id: post.user_id, post_id: post_id)
      questioner.update(notice: true) unless questioner.notice
    else # 自己解決した場合は回答者に通知を送信
      post.send_notice_to_answerers
    end
  end
end
