class ChangeAffiliationColumnOnProfile < ActiveRecord::Migration[6.0]
  def up
    # NULL制約の追加
    change_column_null :profiles, :affiliation, false, "大学生"
    # テーブルの制約にdefault値を設定する
    change_column :profiles, :affiliation, :string, default: "大学生"
  end

  def down
    change_column_null :profiles, :attiliation, true, nil
    change_column :profiles, :affiliation, :string, default: nil
  end
end
