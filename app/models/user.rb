class User < ApplicationRecord
  include UserHelpers
  mount_uploader :avatar, AvatarUploader
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  before_create :generate_authentication_token!

  validates :first_name, :last_name, presence: true

  has_many :carts, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_products, through: :favourites, source: :favourited, source_type: 'Product'

  def generate_authentication_token!
    self.authentication_token = Devise.friendly_token
  end

end
