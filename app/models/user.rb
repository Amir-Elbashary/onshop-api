class User < ApplicationRecord
  include UserHelpers
  enum gender: %i[unspecified male female]
  mount_uploader :avatar, AvatarUploader
  # :confirmable, :lockable, :timeoutable, :trackable
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true

  has_many :logins, dependent: :destroy
  has_many :orders # Won't be destroyed for now even if user was destroyed
  has_many :carts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_products, through: :favourites, source: :favourited, source_type: 'Product'

  def self.from_omniauth(auth) 
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.email = auth.info.email
      user.first_name = auth.first_name
      user.last_name = auth.last_name
      user.password = Devise.friendly_token[0, 20]
    end
  end
end
