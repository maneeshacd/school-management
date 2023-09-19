require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Associations' do
    it { should have_many(:student_enrollments).class_name('Enrollment').with_foreign_key('student_id') }
    it { should have_many(:student_batches).through(:student_enrollments).source(:batch) }
    it { should have_many(:enrolled_courses).through(:student_batches).source(:course) }
    it { should belong_to(:school).optional }
    it { should have_many(:enrollment_approved_courses).through(:student_batches).source(:course).conditions(batches: { enrollments: { status: :approved } })}
    it { should have_many(:enrollment_rejected_courses).through(:student_batches).source(:course).conditions(batches: { enrollments: { status: :rejected } })}
    it { should have_many(:enrollment_pending_courses).through(:student_batches).source(:course).conditions(batches: { enrollments: { status: :pending } })}
  end

  describe 'Validations' do
    subject { create(:user) }

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:role) }
  end

  describe '.classmates' do
    let!(:school) { create(:school) }
    let!(:student) { create(:user, role: :student, school: school) }
    let!(:not_classmate) { create(:user, role: :student, school: school) }
    let!(:classmate) { create(:user, role: :student, school: school) }
    let!(:course) { create(:course, school: school) }
    let!(:batch) { create(:batch, course: course) }
    let!(:enrollment1) { create(:enrollment, student: student, batch: batch, school: school, status: :approved) }
    let!(:enrollment2) { create(:enrollment, student: classmate, batch: batch, school: school, status: :approved) }

    it 'includes classmates' do
      expect(student.classmates(batch)).to include(classmate)
    end

    it 'excludes classmates' do
      expect(student.classmates(batch)).not_to include(not_classmate)
    end
  end

  describe '.user_school' do
    it 'should return error for student craetion without school id' do
      s1 = User.create(name: 's1', email: 's1@gmail.com', role: :student, password: 'password', password_confirmation: 'password')
      expect(s1.errors.full_messages).to eq(['School id cannot be blank'])
    end

    it 'should return error for school admin craetion without school id' do
      s1 = User.create(name: 's1', email: 's1@gmail.com', role: :school_admin, password: 'password', password_confirmation: 'password')
      expect(s1.errors.full_messages).to eq(['School id cannot be blank'])
    end

    it 'should not return error if admin' do
      admin = User.create(name: 's1', email: 's1@gmail.com', role: :admin, password: 'password', password_confirmation: 'password')
      expect(admin.errors.full_messages).to eq([])
    end
  end
end
