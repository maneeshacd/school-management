class Enrollment < ApplicationRecord
  enum :status, %w[pending approved rejected]

  belongs_to :student, class_name: 'User', foreign_key: :student_id
  belongs_to :batch

  validates_uniqueness_of :student_id, scope: :batch_id

  before_destroy :validate_status

  def validate_status
    unless pending?
      errors.add(:base, 'Only pending enrollment can be deleted')
      throw(:abort)
    end
  end
end
