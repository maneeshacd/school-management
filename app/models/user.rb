class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User

  belongs_to :school, optional: true
  has_many :student_enrollments, class_name: 'Enrollment', foreign_key: :student_id
  has_many :student_batches, through: :student_enrollments, source: :batch
  has_many :enrolled_courses, through: :student_batches, source: :course
  has_many :classmates, -> (user) {
    where(enrollments: { status: 1 }).where.not(id: user).distinct
  }, through: :student_batches, source: :students

  enum :role, %w[school_admin student admin]

  def self.ransackable_attributes(auth_object = nil)
    [
      'created_at', 'name', 'email', 'description', 'encrypted_password', 'id',
      'remember_created_at', 'reset_password_sent_at',
      'reset_password_token', 'updated_at'
    ]
  end
end
