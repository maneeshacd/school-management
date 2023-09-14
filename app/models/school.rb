class School < ApplicationRecord
  has_many :users
  has_many :courses

  def self.ransackable_attributes(auth_object = nil)
    ['created_at', 'description', 'id', 'name', 'updated_at']
  end

  def self.ransackable_associations(auth_object = nil)
    ['users', 'courses']
  end
end
