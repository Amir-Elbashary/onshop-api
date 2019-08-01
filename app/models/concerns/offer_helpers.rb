module OfferHelpers
  extend ActiveSupport::Concern

  def active?
    return true if Time.zone.now.between?(starts_at, ends_at)
    false
  end
end
