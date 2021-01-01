class Referral < ApplicationRecord
  validates :referral_code, uniqueness: true, presence: true
end
