class Cart < ApplicationRecord
  # State refers to whether this cart is the current
  # active cart for the user or not regardless of ordering status
  enum state: %i[inactive active]

  # Status refers to the ability to add/modify items or not
  # in case of having an order then the cart is locked, and once
  # the order is canceled, the cart will be unlocked
  enum status: %i[locked unlocked]

  has_many :items, dependent: :destroy
  has_one :order # Won't be destroyed for now even if the cart was destroyed
  belongs_to :user
end
