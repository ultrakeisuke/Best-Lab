class RenameUniversityColumnToProfiles < ActiveRecord::Migration[6.0]
  def change
    rename_column :profiles, :university, :school
  end
end
