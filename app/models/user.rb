class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :delete_all

  validates(:login_id, format: { with: /\A[a-zA-Z0-9]+\z/,  message: :only_alphameric }, presence: true, uniqueness: true)
  validates(:password, format: { with: /\A[a-zA-Z0-9]+\z/,  message: :only_alphameric }, length: { minimum: 8 })
end
