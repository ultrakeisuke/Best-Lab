class AddAffiliationToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :affiliation, :integer, null: false, default: 0
  end
end