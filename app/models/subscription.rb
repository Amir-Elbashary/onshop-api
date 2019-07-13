class Subscription < ApplicationRecord
  enum status: %i[inactive active]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX  }
  validates :email, uniqueness: { case_sensitive: false }
end
