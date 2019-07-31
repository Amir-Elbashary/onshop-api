class Variant < ApplicationRecord
  mount_uploader :image, ImageUploader
  translates :name, :color, :size, fallbacks_for_empty_translations: true
  globalize_accessors locales: [:en, :ar]
  globalize_validations locales: [:en, :ar]

  Globalize.fallbacks = { en: [:en, :ar], ar: [:ar, :en] }

  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  validate :validates_globalized_attributes

  belongs_to :product
end
