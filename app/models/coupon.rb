class Coupon < ApplicationRecord
  include OfferHelpers
  #before_create :generate_coupon_code!
  before_validation :generate_coupon_code!, on: :create

  validates :percentage, :code, :starts_at, :ends_at, presence: true
  validates :percentage, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  def generate_coupon_code!
    # Random, unguessable number as a base20 string
    # .reverse ensures we don't use first character (which may not take all values)
    raw_string = SecureRandom.random_number( 2**80 ).to_s( 20 ).reverse
    # e.g. "efdcb89gb2fa230c2j2"

    # Convert Ruby base 20 to better characters for user experience
    long_code = raw_string.tr('0123456789abcdefghij', '234679QWERTYUPADFGHX')
    # e.g. "ADPUYERFY4DT462U4X4"

    # Format the code for printing
    friendly_code = long_code[0..3] + '-' + long_code[4..7] + '-' + long_code[8..11]
    # e.g. "ADPU-YERF-Y4DT"

    self.code = friendly_code
  end
end
