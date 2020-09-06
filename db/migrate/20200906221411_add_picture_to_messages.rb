class AddPictureToMessages < ActiveRecord::Migration[6.0]
  def change
    add_column :messages, :picture, :string
  end
end
