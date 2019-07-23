class Label < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { maximum: 16 }

  before_validation :remove_whitespaces

  def remove_whitespaces
    name.strip!
  end
end
