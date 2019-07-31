class Label < ApplicationRecord
  NAME_LENGTH_MAX = 16

  belongs_to :user
  has_many :labels_tasks, dependent: :delete_all
  has_many :tasks, through: :labels_tasks
  validates :name, presence: true, length: { maximum: NAME_LENGTH_MAX }

  before_validation :strip_whitespaces
  validate :labels_user_can_have, on: [:create]

  private

    def strip_whitespaces
      name.strip!
    end

    def labels_user_can_have
      # TODO: ラベル側ではなくユーザー側に保持できるラベル数(20)を移動させ定数化する
      errors.add(:base, :too_many, count: 20) if user.labels.size > 20
    end
end
