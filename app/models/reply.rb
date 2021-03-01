class Reply < ApplicationRecord
  has_many :pictures, as: :imageable, dependent: :destroy
  belongs_to :user
  belongs_to :post
  belongs_to :answer

  # リプライ時に質問者と回答者に通知を送信する処理
  def send_notice_to_questioner_and_answerer
    if user != post.user # 質問者でない場合は質問者に通知を送信
      questioner = QuestionEntry.find_by(user_id: post.user_id, post_id: post_id)
      questioner.update(notice: true) unless questioner&.notice
    end
    if user != answer.user # 回答者でない場合は回答者に通知を送信
      answerer = QuestionEntry.find_by(user_id: answer.user_id, post_id: post_id)
      answerer.update(notice: true) unless answerer&.notice
    end
  end

  # 自分以外で回答にリプライした人も含めて通知を送信する処理
  def send_notice_to_commenter
    # 初めてコメントする場合は通知用レコードを作成
    QuestionEntry.find_or_create_by(user_id: user_id, post_id: post_id)
    # 回答に紐づくリプライヤーに通知を送信
    replier_ids = answer.replies.map(&:user_id)
    repliers = QuestionEntry.where(user_id: replier_ids, post_id: post_id).where.not(user_id: user_id)
    repliers.each do |replier|
      replier.update(notice: true) unless replier.notice
    end
    send_notice_to_questioner_and_answerer # 質問者と回答者に通知を送信
  end
end
