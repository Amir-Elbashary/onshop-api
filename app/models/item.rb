class Item < ApplicationRecord
  validates :quantity, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :variant_id, uniqueness: { case_sensitive: false, scope: :cart_id }

  belongs_to :cart
  belongs_to :variant
end
