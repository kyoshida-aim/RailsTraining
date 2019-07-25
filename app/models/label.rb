class Label < ApplicationRecord
  belongs_to :user
  has_many :labels_tasks, dependent: :delete_all
  has_many :tasks, through: :labels_tasks
  validates :name, presence: true, length: { maximum: 16 }

  before_validation :remove_whitespaces

  def remove_whitespaces
    name.strip!
  end
end
