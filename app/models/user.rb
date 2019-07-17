class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :delete_all

  validates(:login_id, presence: true, uniqueness: true)
end
