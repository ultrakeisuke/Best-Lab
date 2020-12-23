class CreateReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :replies do |t|
      t.string :boty

      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, fereign_key: true

      t.timestamps
    end
  end
end
