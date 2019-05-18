class Cart < ApplicationRecord
  enum state: %i[inactive active]

  belongs_to :user
end
