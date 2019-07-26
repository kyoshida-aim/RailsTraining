class Label < ApplicationRecord
  NAME_SIZE_MAX = 16

  belongs_to :user
  validates :name, presence: true, length: { maximum: NAME_SIZE_MAX }

  before_validation :strip_whitespaces
  validate :labels_user_can_have, on: [:create]

  private

    def strip_whitespaces
      name.strip!
    end

    def labels_user_can_have
      errors.add(:base, :too_many, count: 20) if user.labels.size > 20
    end
end
