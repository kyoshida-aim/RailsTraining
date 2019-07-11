class Task < ApplicationRecord
  enum status: { not_started: 0, in_progress: 1, finished: 2 }
  enum priority: { low: 0, middle: 1, high: 2 }

  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_deadline_minimum_value

  belongs_to :user

  def self.ransackable_attributes(auth_object = nil)
    %w[name status deadline priority]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  private

    def validate_deadline_minimum_value
      errors.add(:deadline, :after) if !deadline.nil? && deadline < Time.zone.now
    end
end
