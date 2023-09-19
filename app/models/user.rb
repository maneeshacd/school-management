class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :school, optional: true
  has_many :student_enrollments, class_name: 'Enrollment', foreign_key: :student_id
  has_many :student_batches, through: :student_enrollments, source: :batch
  has_many :enrolled_courses, through: :student_batches, source: :course

  enum :role, %w[school_admin student admin]

  validates :name, :email, :role, presence: true
  validate :user_school, on: :create
  before_create :add_jti

  def add_jti
    self.jti ||= SecureRandom.uuid
  end

  def user_school
    errors.add(:base, "School id cannot be blank") if (student? || school_admin?) && school_id.nil?
  end

  def classmates(batch_id)
    User.includes(:student_enrollments)
      .where(student_enrollments: { batch_id: batch_id })
      .where.not(id: id)
  end
end
