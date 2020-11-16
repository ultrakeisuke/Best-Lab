class ChangeDataAffiliationToProfiles < ActiveRecord::Migration[6.0]
  def change
    change_column :profiles, :affiliation, :string
  end
end
