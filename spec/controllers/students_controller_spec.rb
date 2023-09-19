# spec/controllers/students_controller_spec.rb

require 'rails_helper'

RSpec.describe StudentsController, type: :controller do
  let!(:school) { create(:school) }
  let!(:user) { create(:user, role: :student) }
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
end
