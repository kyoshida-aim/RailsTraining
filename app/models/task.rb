class Task < ApplicationRecord
  class InvalidLabelIdGiven < StandardError; end

  enum status: { not_started: 0, in_progress: 1, finished: 2 }
  enum priority: { low: 0, middle: 1, high: 2 }

  before_validation :check_label_owner

  validates :name, presence: true, length: { maximum: 30 }
  validate :validate_deadline_minimum_value
  validate :validate_number_of_labels_in_one_task

  belongs_to :user
  has_many :labels_tasks, dependent: :delete_all
  has_many :labels, through: :labels_tasks

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

    def validate_number_of_labels_in_one_task
      errors.add(:labels, :too_many, count: 10) if labels.size > 10
    end

    def check_label_owner
      invalid_labels = labels - user.labels
      if invalid_labels.present?
        invalid_ids = invalid_labels.collect(&:id)
        messages = "Params contain Label that user does not own.ids:#{invalid_ids}"
        raise InvalidLabelIdGiven, messages
      end
    end
end
