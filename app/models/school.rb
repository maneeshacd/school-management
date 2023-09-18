class School < ApplicationRecord
  has_many :admins, -> { where(users: { role: 0 }) }, class_name: 'User', foreign_key: :school_id, dependent: :destroy
  has_many :students, -> { where(users: { role: 1 }) }, class_name: 'User', foreign_key: :school_id, dependent: :destroy
  has_many :courses

  validates :name, :description, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['created_at', 'description', 'id', 'name', 'updated_at']
  end

  def self.ransackable_associations(auth_object = nil)
    ['users', 'courses']
  end
end
