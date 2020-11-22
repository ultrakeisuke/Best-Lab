class ProfileForm
  include ActiveModel::Model
  include Virtus.model

  AFFILIATION_VALUES = [ '大学生', '大学院生', '高専生', '専門学生', '社会人', 'その他' ]

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

  attr_accessor :profile

  def initialize(profile = Profile.new)
    @profile = profile
    # プロフィールが保存済みならProfileFormのattributesに代入
    self.attributes = @profile.attributes if profile.persisted?
  end

  def assign_attributes(params = {})
    @params = params
    # ユーザーがすでにprofileを持っている場合、profileのattributesを更新
    profile.assign_attributes(profile_form_params) if profile.persisted?
    # 更新情報をバリデーションするため、ProfileFormのattributesも変更
    super(profile_form_params)
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
                            content: content,
                            user_id: user_id)
      profile.save!
    end
  end

  private

    def profile_form_params
      @params.require(:profile_form).permit(:affiliation, :school, :faculty, :department, :laboratory, :content)
    end

    def at_least_one_parameter
      if affiliation.blank? && school.blank? && faculty.blank? && department.blank? && laboratory.blank? && content.blank?
        errors.add(:base, "最低でも1つの項目を入力してください。")
      end
    end

end
