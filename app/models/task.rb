class Task < ApplicationRecord
  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_deadline_minimum_value

  private

    def validate_deadline_minimum_value
      errors.add(:deadline, "は現在時刻以降に設定してください") if !deadline.nil? && deadline < Time.zone.now
    end
end
