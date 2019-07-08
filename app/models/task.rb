class Task < ApplicationRecord
  enum status: I18n.t(["not_started", "in_progress", "finished"], scope: "activerecord.attributes.task")

  validates :name, presence: true, length: { maximum: 30 }

  def self.ransackable_attributes(auth_object = nil)
    %w[name status deadline]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
