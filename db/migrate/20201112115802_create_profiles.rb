class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.string :affiliation, null: false, default: "大学生"
      t.string :school
      t.string :faculty
      t.string :department
      t.string :laboratory
      t.text :content

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
