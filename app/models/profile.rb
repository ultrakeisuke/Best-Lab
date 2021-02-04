class Profile < ApplicationRecord
  belongs_to :user

  AFFILIATIONS = { undergraduate: '大学生',
                   graduate: '大学院生',
                   technical_students: '高専生',
                   professional_students: '専門学生',
                   working: '社会人',
                   other: 'その他' }

  # 英語名で保存された所属(affiliation)を日本語で表示
  def translated_affiliation
    AFFILIATIONS[self.affiliation.to_sym]
  end
  
end
