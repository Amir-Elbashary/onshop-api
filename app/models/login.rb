class Login < ApplicationRecord
  belongs_to :admin, optional: true
  belongs_to :merchant, optional: true
  belongs_to :user, optional: true
end
