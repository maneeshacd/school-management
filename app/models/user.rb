class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  belongs_to :school

  enum :role, %w[school_admin student]

  def self.ransackable_attributes(auth_object = nil)
    [
      'created_at', 'name', 'email', 'description', 'encrypted_password', 'id',
      'remember_created_at', 'reset_password_sent_at',
      'reset_password_token', 'updated_at'
    ]
  end
end
