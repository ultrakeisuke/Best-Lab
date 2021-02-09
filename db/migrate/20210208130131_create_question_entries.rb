class CreateQuestionEntries < ActiveRecord::Migration[6.0]
  def change
    create_table :question_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.boolean :notice, null: false, default: false

      t.timestamps
    end
  end
end
