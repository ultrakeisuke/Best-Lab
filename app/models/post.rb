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

  # 質問投稿者用の通知レコードを作成
  def create_entry
    QuestionEntry.create(user_id: self.user_id, post_id: self.id)
  end

  # ベストアンサー決定時に回答者全員に通知を送信する
  def send_notice_to_answerers
    answerers = QuestionEntry.where(post_id: self).where.not(user_id: self.user_id)
    answerers.each do |answerer|
      answerer.update(notice: true) if answerer.notice == false
    end
  end

end
