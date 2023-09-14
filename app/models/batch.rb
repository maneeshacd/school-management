class Batch < ApplicationRecord
  belongs_to :course
  has_many :enrollments
  has_many :students, through: :enrollments, source: :student

  validates :name, :start_date, :end_date, presence: true
  validates_comparison_of :end_date, greater_than: :start_date, message: 'must be greater than start date'
end
