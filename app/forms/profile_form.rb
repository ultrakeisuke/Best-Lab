class ProfileForm
  include ActiveModel::Model
  include Virtus.model

  AFFILIATION_VALUES = [ 'undergraduate', 'graduate', 'technical_college', 'college', 'working', 'the_others' ]

  validates :affiliation, inclusion: { in: AFFILIATION_VALUES }
  validates :school,     length: { maximum: 50 }
  validates :faculty,    length: { maximum: 50 }
  validates :department, length: { maximum: 50 }
  validates :laboratory, length: { maximum: 50 }
  validates :content,    length: { maximum: 200 }
  validate :at_least_one_parameter

  attribute :affiliation, String
  attribute :school,      String
  attribute :faculty,     String
  attribute :department,  String
  attribute :laboratory,  String
  attribute :content,     String
  attribute :user_id,     Integer

  def save
    return false if invalid?
    profile = Profile.new(affiliation: affiliation,
                          school: school,
                          faculty: faculty,
                          department: department,
                          laboratory: laboratory,
                          content: content,
                          user_id: user_id)
    profile.save!
  end

  private

    def at_least_one_parameter
      if affiliation.blank? && school.blank? && faculty.blank? && department.blank? && laboratory.blank? && content.blank?
        errors.add(:base, "最低でも1つの項目を入力してください。")
      end
    end

end
