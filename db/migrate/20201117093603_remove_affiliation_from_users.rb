class RemoveAffiliationFromUsers < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :affiliation, :integer
  end
end
