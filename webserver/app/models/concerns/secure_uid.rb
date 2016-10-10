module SecureUID
  extend ActiveSupport::Concern

  def generate_secure_uid
    digits = (0..9).to_a
    chars = ('a'..'z').to_a
    cap_chars = ('A'..'Z').to_a

    result = chars.shuffle.take(5) + digits.shuffle.take(5) + cap_chars.shuffle.take(5)
    result.shuffle.join
  end
end
