class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  # General Scopes
  scope :newest_first, -> { order(created_at: :desc) } 
end
