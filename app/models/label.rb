class Label < ApplicationRecord
  NAME_SIZE_MAX = 16

  belongs_to :user
  validates :name, presence: true, length: { maximum: NAME_SIZE_MAX }

  before_validation :remove_whitespaces

  def remove_whitespaces
    name.strip!
  end
end
