# spec/controllers/students_controller_spec.rb

require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  let!(:school) { create(:school) }
  let!(:school_admin) { create(:user, role: :school_admin, school: school) }
  let!(:user) { create(:user, role: :student, school: school) }
  let!(:classmate) { create(:user, role: :student) }
  let!(:not_classmate) { create(:user, role: :student) }
  let!(:course) { create(:course, school: school) }
  let!(:batch) { create(:batch, course: course) }
  let!(:enrollment1) { create(:enrollment, batch: batch, student: user, school: school) }
  let!(:enrollment2) { create(:enrollment, batch: batch, student: classmate, school: school) }

  before do
    sign_in(user)
  end

  describe "GET #classmates" do
    it "assigns @batch_id" do
      get :classmates, params: { id: batch.id }
      expect(assigns(:batch_id).to_i).to eq(batch.id)
    end

    it "assigns @classmates" do
      get :classmates, params: { id: batch.id }
      expect(assigns(:classmates)).to eq([classmate])
    end

    it "should not include student who is not a classmate" do
      get :classmates, params: { id: batch.id }
      expect(assigns(:classmates)).not_to eq([not_classmate])
    end

    it "renders the classmates template" do
      get :classmates, params: { id: batch.id }
      expect(response).to render_template("classmates")
    end
  end

  describe 'GET #index' do
    before { sign_in(school_admin) }
    it 'authorizes the user' do
      expect(controller).to receive(:authorize).with(:student)
      get :index
    end

    it 'assigns students' do
      get :index
      expect(assigns(:students)).to eq([user])
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    before { sign_in(school_admin) }

    it 'authorizes the user' do
      expect(controller).to receive(:authorize).with(:student)
      get :show, params: { course_id: course.id, id: user.id }
    end

    it 'assigns course and batches' do
      get :show, params: { course_id: course.id, id: user.id }
      expect(assigns(:course)).to eq(course)
      expect(assigns(:batches)).to eq([batch])
    end

    it 'assigns the student' do
      get :show, params: { course_id: course.id, id: user.id }
      expect(assigns(:student)).to eq(user)
    end

    it 'renders the show template' do
      get :show, params: { course_id: course.id, id: user.id }
      expect(response).to render_template(:show)
    end
  end
end
