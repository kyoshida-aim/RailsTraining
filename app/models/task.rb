class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_deadline_minimum_value

  private

    def validate_deadline_minimum_value
      errors.add(:deadline, :after) if !deadline.nil? && deadline < Time.zone.now
    end
end
