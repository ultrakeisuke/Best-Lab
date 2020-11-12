class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.integer :affiliation
      t.string :university
      t.string :school
      t.string :department
      t.string :laboratory
      t.string :content

      t.timestamps
    end
  end
end
