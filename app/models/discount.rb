class Discount < ApplicationRecord
  validates :percentage, :starts_at, :ends_at, presence: true
  validates :percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  belongs_to :merchant
  belongs_to :product

  def active?
    return true if Time.zone.now.between?(starts_at, ends_at)
    false
  end
end
