class Reply < ApplicationRecord
  has_many :pictures, as: :imageable, dependent: :destroy
  belongs_to :user
  belongs_to :post
  belongs_to :answer

  # リプライ時に質問者と回答者に通知を送信する処理
  def send_notice_to_questioner_and_answerer
    # 質問者や回答者自身に通知を送信しないよう制限する
    questioner = QuestionEntry.find_by(user_id: self.post.user_id, post_id: self.post_id)
    questioner.update(notice: true) if questioner.notice == false && self.user != self.post.user
    answerer = QuestionEntry.find_by(user_id: self.answer.user_id, post_id: self.post_id)
    answerer.update(notice: true) if answerer.notice == false && self.user != self.answer.user
  end

  # 返信者も含めて通知を送信する処理
  def send_notice_to_commenter
    # 初めてコメントする場合は通知用レコードを作成
    if QuestionEntry.find_by(user_id: self.user_id, post_id: self.post_id).blank?
      QuestionEntry.create(user_id: self.user_id, post_id: self.post_id)
    end
    # 回答に紐づく返信者に通知を送信
    replier_ids = self.answer.replies.map { |reply| reply.user_id }
    repliers = QuestionEntry.where(user_id: replier_ids, post_id: self.post_id).where.not(user_id: self.user_id)
    repliers.each do |replier|
      replier.update(notice: true) if replier.notice == false
    end
    self.send_notice_to_questioner_and_answerer # 質問者と回答者に通知を送信
  end

end
