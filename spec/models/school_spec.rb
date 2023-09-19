require 'rails_helper'

RSpec.describe School, type: :model do
  describe 'Associations' do
    it { should have_many(:school_admins).class_name('User').with_foreign_key('school_id').dependent(:destroy).conditions(users: { role: :school_admin })}
    it { should have_many(:students).class_name('User').with_foreign_key('school_id').dependent(:destroy).conditions(users: { role: :student })}
    it { should have_many(:courses) }
    it { should have_many(:enrollments) }
  end

  describe 'Validations' do
    subject { create(:school) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
  end
end
