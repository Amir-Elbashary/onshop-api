class Category < ApplicationRecord
  acts_as_tree order: 'name'   
  mount_uploader :image, ImageUploader
  translates :name, fallbacks_for_empty_translations: true
  globalize_accessors locales: [:en, :ar]
  globalize_validations locales: [:en, :ar]

  Globalize.fallbacks = { en: [:en, :ar], ar: [:ar, :en] }

  validates :name, presence: true

  validate :validates_globalized_attributes

  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_id'
  has_many :products, dependent: :destroy
  belongs_to :parent, class_name: 'Category', optional: true

  # accepts_nested_attributes_for :sub_categories, allow_destroy: true,
  #                                                reject_if: ->(a) { a[:name].blank? }
end
