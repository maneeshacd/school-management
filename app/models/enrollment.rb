class Enrollment < ApplicationRecord
  enum :status, %w[pending approved rejected]

  belongs_to :student, class_name: 'User', foreign_key: :student_id
  belongs_to :batch
end
