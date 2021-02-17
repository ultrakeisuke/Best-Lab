class ProfileForm
  include ActiveModel::Model
  include Virtus.model

  AFFILIATION_VALUES = [ 'undergraduate', 'graduate', 'technical_students', 'professional_students', 'working', 'other' ]

  AFFILIATIONS = { undergraduate: '大学生',
                   graduate: '大学院生',
                   technical_students: '高専生',
                   professional_students: '専門学生',
                   working: '社会人',
                   other: 'その他' }
  
  validates :affiliation, inclusion: { in: AFFILIATION_VALUES }
  validates :school,      length: { maximum: 50 }
  validates :faculty,     length: { maximum: 50 }
  validates :department,  length: { maximum: 50 }
  validates :laboratory,  length: { maximum: 50 }
  validates :description, length: { maximum: 200 }
  validate :at_least_one_parameter

  attribute :affiliation, String
  attribute :school,      String
  attribute :faculty,     String
  attribute :department,  String
  attribute :laboratory,  String
  attribute :description, String
  attribute :user_id,     Integer

  attr_accessor :profile

  def initialize(profile = Profile.new)
    @profile = profile
  end

  def assign_attributes(params = {})
    # ユーザーがすでにprofileを持っている場合はそのattributesを更新
    profile.assign_attributes(params) if profile.persisted?
    # バリデーションにかけるためフォームオブジェクトの値も更新
    super(params)
  end

  def save
    return false if invalid?
    if profile.persisted? # profileを持っている場合はそのまま保存
      profile.save!
    else # prifileを持っていない場合はProfileオブジェクトに変換して保存
      profile = Profile.new(affiliation: affiliation,
                            school: school,
                            faculty: faculty,
                            department: department,
                            laboratory: laboratory,
                            description: description,
                            user_id: user_id)
      profile.save!
    end
  end

  private

    def at_least_one_parameter
      if affiliation.blank? && school.blank? && faculty.blank? && department.blank? && laboratory.blank? && description.blank?
        errors.add(:base, "最低でも1つの項目を入力してください。")
      end
    end

end
