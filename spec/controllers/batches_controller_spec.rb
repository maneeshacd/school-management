# spec/controllers/batches_controller_spec.rb

require 'rails_helper'

RSpec.describe BatchesController, type: :controller do
  let(:school) { create(:school) }
  let(:school_admin) { create(:user, role: :school_admin, school: school) }
  let(:course) { create(:course, school: school) }
  let(:batch) { create(:batch, course: course) }

  before do
    sign_in(school_admin)
  end

  describe "GET #index" do
    it "assigns @batches" do
      get :index, params: { course_id: course.id }
      expect(assigns(:batches)).to eq(course.batches)
    end

    it "renders the index template" do
      get :index, params: { course_id: course.id }
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    let!(:student) { create(:user, role: :student, school: school) }
    let!(:course) { create(:course, school: school) }
    let!(:batch) { create(:batch, course: course) }
    let!(:enrollment) { create(:enrollment, batch: batch, student: student, school: school, status: :approved) }

    it "assigns @batch" do
      get :show, params: { course_id: course.id, id: batch.id }
      expect(assigns(:batch)).to eq(batch)
    end

    it "assigns @enrolled" do
      sign_in(student)
      get :show, params: { course_id: course.id, id: batch.id }
      expect(assigns(:enrolled)).to eq(student.student_batches.include?(batch))
    end

    it "renders the show template" do
      get :show, params: { course_id: course.id, id: batch.id }
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    it "assigns a new @batch" do
      get :new, params: { course_id: course.id }
      expect(assigns(:batch)).to be_a_new(Batch)
    end

    it "renders the new template" do
      get :new, params: { course_id: course.id }
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    it "assigns @batch" do
      get :edit, params: { course_id: course.id, id: batch.id }
      expect(assigns(:batch)).to eq(batch)
    end

    it "renders the edit template" do
      get :edit, params: { course_id: course.id, id: batch.id }
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    it "creates a new batch" do
      expect {
        post :create, params: { course_id: course.id, batch: attributes_for(:batch) }
      }.to change(Batch, :count).by(1)
    end

    it "redirects to course_batch_url on success" do
      post :create, params: { course_id: course.id, batch: attributes_for(:batch) }
      expect(response).to redirect_to(course_batch_url(course, Batch.last))
    end

    it "sets a flash notice after creating" do
      post :create, params: { course_id: course.id, batch: attributes_for(:batch) }
      expect(flash[:notice]).to eq("Batch was successfully created.")
    end

    it "renders the new template on failure" do
      allow_any_instance_of(Batch).to receive(:save).and_return(false)
      post :create, params: { course_id: course.id, batch: attributes_for(:batch) }
      expect(response).to render_template("new")
    end
  end

  describe "PATCH #update" do
    it "updates the batch" do
      new_name = "New Batch Name"
      patch :update, params: { course_id: course.id, id: batch.id, batch: { name: new_name } }
      batch.reload
      expect(batch.name).to eq(new_name)
    end

    it "redirects to course_batch_url on success" do
      patch :update, params: { course_id: course.id, id: batch.id, batch: attributes_for(:batch) }
      expect(response).to redirect_to(course_batch_url(course, batch))
    end

    it "sets a flash notice after updating" do
      patch :update, params: { course_id: course.id, id: batch.id, batch: attributes_for(:batch) }
      expect(flash[:notice]).to eq("Batch was successfully updated.")
    end

    it "renders the edit template on failure" do
      allow_any_instance_of(Batch).to receive(:update).and_return(false)
      patch :update, params: { course_id: course.id, id: batch.id, batch: attributes_for(:batch) }
      expect(response).to render_template("edit")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the batch" do
      batch  # Ensure the batch is created
      expect {
        delete :destroy, params: { course_id: course.id, id: batch.id }
      }.to change(Batch, :count).by(-1)
    end

    it "redirects to course_batches_url on success" do
      delete :destroy, params: { course_id: course.id, id: batch.id }
      expect(response).to redirect_to(course_batches_url(course))
    end

    it "sets a flash notice after destroying" do
      delete :destroy, params: { course_id: course.id, id: batch.id }
      expect(flash[:notice]).to eq("Batch was successfully destroyed.")
    end

    it "renders the show template on failure" do
      allow_any_instance_of(Batch).to receive(:destroy).and_return(false)
      delete :destroy, params: { course_id: course.id, id: batch.id }
      expect(flash[:notice]).to eq("not deleted.")
    end
  end
end
