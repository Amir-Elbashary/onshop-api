class Merchant < ApplicationRecord
  include UserHelpers
  enum gender: %i[unspecified male female]
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  has_many :logins, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :discounts, dependent: :destroy
end
