class Account < ApplicationRecord
  validates :email, :referral_code, allow_nil: true, uniqueness: true
  validates :cpf, uniqueness: true, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_nil: true
end
