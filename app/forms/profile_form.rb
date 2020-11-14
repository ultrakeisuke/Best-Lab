class ProfileForm
  include ActiveModel::Model
  include Virtus.model

  validates :school,     length: { maximum: 50 }
  validates :faculty,    length: { maximum: 50 }
  validates :department, length: { maximum: 50 }
  validates :laboratory, length: { maximum: 50 }
  validates :content,    length: { maximum: 200 }
  validates :at_least_one_parameter, presence: true

  attribute :affiliation, Integer
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
      affiliation.presence or school.presence or faculty.presence or department.presence or laboratory.presence or content.presence
    end

end
