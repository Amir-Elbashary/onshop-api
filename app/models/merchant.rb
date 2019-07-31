class Merchant < ApplicationRecord
  include UserHelpers
  enum gender: %i[unspecified male female]
  mount_uploader :avatar, AvatarUploader
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  before_create :generate_authentication_token!

  validates :first_name, :last_name, presence: true

  has_many :logins, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :discounts, dependent: :destroy

  def generate_authentication_token!
    self.authentication_token = Devise.friendly_token
  end
end
