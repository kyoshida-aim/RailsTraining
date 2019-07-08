class Task < ApplicationRecord
  enum status: I18n.t(["not_started", "in_progress", "finished"], scope: "activerecord.attributes.task")

  validates :name, presence: true, length: { maximum: 30 }
end
