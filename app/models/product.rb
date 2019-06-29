class Product < ApplicationRecord
  mount_uploader :image, ImageUploader
  translates :name, :description, fallbacks_for_empty_translations: true
  globalize_accessors locales: [:en, :ar]
  globalize_validations locales: [:en, :ar]

  Globalize.fallbacks = { en: [:en, :ar], ar: [:ar, :en] }

  validates :name, presence: true
  validates :name, uniqueness: { case_sensitive: false, scope: :merchant_id }

  validate :validates_globalized_attributes

  has_many :variants, dependent: :destroy
  has_many :reviews, dependent: :destroy
  belongs_to :merchant
  belongs_to :category

  # accepts_nested_attributes_for :variants, allow_destroy: true,
  #                                          reject_if: ->(a) { a[:name].blank? }
end
