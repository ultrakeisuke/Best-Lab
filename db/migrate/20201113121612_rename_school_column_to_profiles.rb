class RenameSchoolColumnToProfiles < ActiveRecord::Migration[6.0]
  def change
    rename_column :profiles, :school, :faculty
  end
end
