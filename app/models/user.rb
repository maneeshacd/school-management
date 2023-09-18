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

  validate :user_school, on: :create
  before_create :add_jti

  def add_jti
    self.jti ||= SecureRandom.uuid
  end

  def user_school
    errors.add(:kind, "School id cannot be blank") if student? && school_id.nil?
  end

  def self.ransackable_attributes(auth_object = nil)
    [
      'created_at', 'name', 'email', 'description', 'encrypted_password', 'id',
      'remember_created_at', 'reset_password_sent_at',
      'reset_password_token', 'updated_at'
    ]
  end

  def classmates(batch)
    User.includes(:student_enrollments)
      .where(student_enrollments: { status: 1, batch: batch })
      .where.not(id: id)
  end
end
