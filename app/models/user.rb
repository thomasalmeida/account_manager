class User < ApplicationRecord
  validates :username, uniqueness: true
  validates :username, :password_digest, presence: true
end
