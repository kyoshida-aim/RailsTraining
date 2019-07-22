class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :delete_all
  has_many :labels, dependent: :delete_all

  validates(:login_id, format: { with: /\A[a-zA-Z0-9]+\z/,  message: :only_alphameric }, presence: true, length: { in: 4..20 }, uniqueness: true)
  validates(:password, format: { with: /\A[a-zA-Z0-9]+\z/,  message: :only_alphameric }, presence: true, length: { minimum: 8 }, allow_nil: true)
end
