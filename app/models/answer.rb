class Answer < ApplicationRecord
  has_many :pictures, as: :imageable, dependent: :destroy
  has_many :replies, dependent: :destroy
  belongs_to :user
  belongs_to :post

  # 質問に回答した際の通知処理
  def send_notice_to_questioner_or_answerers
    # 回答時に通知レコードがなければ作成(先にリプライしていた場合は通知レコードが存在するため)
    QuestionNotice.find_or_create_by(user_id: user_id, post_id: post_id)
    if user_id == post.user_id # 自己解決した場合は回答者に通知を送信
      post.send_notice_to_answerers
    else # 自己解決でない場合は質問者に通知を送信
      questioner = QuestionNotice.find_by(user_id: post.user_id, post_id: post_id)
      questioner.update(notice: true) unless questioner.notice
    end
  end
end
