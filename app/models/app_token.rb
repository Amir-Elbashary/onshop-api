class AppToken < ApplicationRecord
  before_create :generate_token

  TOKEN_SPACE = [('a'..'z'), ('A'..'Z'), (0..9),
                 ['-', '_', '@', '~', '*', '&', '^', '%', '$']].map(&:to_a).flatten

  validates :title, uniqueness: { case_sensitive: false }
  validates :token, uniqueness: { case_sensitive: true }

  def generate_token
    self.token = (0...20).map { TOKEN_SPACE[rand(TOKEN_SPACE.length)] }.join if token.nil?
  end
end
