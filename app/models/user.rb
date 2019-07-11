class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :delete_all
end
