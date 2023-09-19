class School < ApplicationRecord
  has_many :school_admins, -> { where(users: { role: :school_admin }) }, class_name: 'User', foreign_key: :school_id, dependent: :destroy
  has_many :students, -> { where(users: { role: :student }) }, class_name: 'User', foreign_key: :school_id, dependent: :destroy
  has_many :courses
  has_many :enrollments

  validates :name, :description, presence: true
end
