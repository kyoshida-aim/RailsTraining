class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :delete_all

  validate :need_admin, on: :update

  validates(:login_id, format: { with: /\A[a-zA-Z0-9]+\z/,  message: :only_alphameric }, presence: true, length: { in: 4..20 }, uniqueness: true)
  validates(:password, format: { with: /\A[a-zA-Z0-9]+\z/,  message: :only_alphameric }, presence: true, length: { minimum: 8 }, allow_nil: true)

  private

    def need_admin
      admin_users = User.where(admin: true)
      if admin_users.size == 1 && admin_users.first == self && !self.admin?
        errors.add(:admin, :need_admin)
      end
    end
end
