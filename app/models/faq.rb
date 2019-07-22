class Faq < ApplicationRecord
  translates :question, :answer, fallbacks_for_empty_translations: true
  globalize_accessors locales: [:en, :ar]
  globalize_validations locales: [:en, :ar]

  Globalize.fallbacks = { en: [:en, :ar], ar: [:ar, :en] }

  validates :question, :answer, presence: true

  validate :validates_globalized_attributes
end
