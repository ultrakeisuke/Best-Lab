class AddNameToAdmins < ActiveRecord::Migration[6.0]
  def change
    add_column :admins, :name, :string, null: false
  end
end
