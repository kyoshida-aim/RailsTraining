class Task < ApplicationRecord
  enum status: { not_started: 0, in_progress: 1, finished: 2 }

  validates :name, presence: true, length: { maximum: 30 }

  def self.ransackable_attributes(auth_object = nil)
    %w[name status deadline]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
