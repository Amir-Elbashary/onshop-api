class Discount < ApplicationRecord
  include OfferHelpers

  validates :percentage, :starts_at, :ends_at, presence: true
  validates :percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  belongs_to :merchant
  belongs_to :product
end
