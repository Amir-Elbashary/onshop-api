class AppSetting < ApplicationRecord
  mount_uploader :logo, ImageUploader
  translates :name, :description, fallbacks_for_empty_translations: true
  globalize_accessors locales: [:en, :ar]
  globalize_validations locales: [:en, :ar]

  Globalize.fallbacks = { en: [:en, :ar], ar: [:ar, :en] }

  validates :name, presence: true

  validate :validates_globalized_attributes
end
