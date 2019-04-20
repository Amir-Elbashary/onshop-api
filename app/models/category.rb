class Category < ApplicationRecord
  acts_as_tree order: 'name'   
  mount_uploader :logo, ImageUploader

  validates :name, presence: true
  # validates :name, uniqueness: { case_sensitive: false }

  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_id'
  belongs_to :parent, class_name: 'Category', optional: true

  accepts_nested_attributes_for :sub_categories, allow_destroy: true,
                                                 reject_if: ->(a) { a[:name].blank? }
end
