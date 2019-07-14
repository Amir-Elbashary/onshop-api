class Contact < ApplicationRecord
  enum status: %i[close open]

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :user_name, presence: true
  validates :email, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX  }
  validates :message, presence: true
end
