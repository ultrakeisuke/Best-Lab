module Partner
  extend ActiveSupport::Concern

  included do
    scope :partner_of, -> (user){where.not(user_id: user).first}
  end
end
