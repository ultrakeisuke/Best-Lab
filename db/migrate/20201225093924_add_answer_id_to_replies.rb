class AddAnswerIdToReplies < ActiveRecord::Migration[6.0]
  def change
    add_reference :replies, :answer, foreign_key: true
  end
end
