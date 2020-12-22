class CreatePictures < ActiveRecord::Migration[6.0]
  def change
    create_table :pictures do |t|
      t.string :picture
      t.references :imageable, polymorphic: true, null: false
      t.timestamps
    end
  end
end
