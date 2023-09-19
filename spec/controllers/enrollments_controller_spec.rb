# spec/controllers/enrollments_controller_spec.rb

require 'rails_helper'

RSpec.describe EnrollmentsController, type: :controller do
  let!(:school) { create(:school) }
  let!(:school_admin) { create(:user, role: :school_admin, school: school) }
  let!(:student) { create(:user, role: :student) }
  let!(:course) { create(:course, school: school) }
  let!(:batch) { create(:batch, course: course) }
  let!(:enrollment) { create(:enrollment, batch: batch, school: school, student: student) }


  describe "GET #index" do
    before { sign_in(school_admin) }

    it "assigns @enrollments" do
      get :index, params: { batch_id: batch.id }
      expect(assigns(:enrollments)).to eq([enrollment])
    end

    it "renders the index template" do
      get :index, params: { batch_id: batch.id }
      expect(response).to render_template("index")
    end
  end

  describe "GET #student_index" do
    before { sign_in(student) }

    it "assigns @enrollments" do
      get :student_index
      expect(assigns(:enrollments)).to eq(student.student_enrollments)
    end

    it "renders the student_index template" do
      get :student_index
      expect(response).to render_template("student_index")
    end
  end

  describe "GET #show" do
    before { sign_in(school_admin) }

    it "assigns @enrollment" do
      get :show, params: { batch_id: batch.id, id: enrollment.id }
      expect(assigns(:enrollment)).to eq(enrollment)
    end

    it "renders the show template" do
      get :show, params: { batch_id: batch.id, id: enrollment.id }
      expect(response).to render_template("show")
    end
  end

  describe "POST #create" do
    context "on success - if user does't have any enrollment exists in the same course" do
      let!(:user) { create(:user, role: :student, school: school) }
      before do
        sign_in(user)
      end
      it "creates a new enrollment" do
        expect {
          post :create, params: { batch_id: batch.id }
        }.to change(Enrollment, :count).by(1)
      end

      it "redirects to enrollments_path on success" do
        post :create, params: { batch_id: batch.id }
        expect(response).to redirect_to(enrollments_path)
      end

      it "sets a flash notice after creating" do
        post :create, params: { batch_id: batch.id }
        expect(flash[:notice]).to eq("Enrollment was successfully created.")
      end
    end

    context 'on failure - if the user has already one enrollment in the same course' do
      it "renders error message" do
        sign_in(student)
        post :create, params: { batch_id: batch.id }
        expect(flash[:alert]).to eq("You already enrolled to another batch of this same course")
      end
    end
  end

  describe "PATCH #update" do
    before do
      sign_in(school_admin)
    end

    it "updates the enrollment status" do
      new_status = 'approved'
      patch :update, params: { batch_id: batch.id, id: enrollment.id, status: new_status }
      enrollment.reload
      expect(enrollment.status).to eq(new_status)
    end

    it "redirects to batch_enrollments_url on success" do
      patch :update, params: { batch_id: batch.id, id: enrollment.id, status: :approved }
      expect(response).to redirect_to(batch_enrollments_url(batch))
    end

    it "sets a flash notice after updating" do
      patch :update, params: { batch_id: batch.id, id: enrollment.id, status: :approved }
      expect(flash[:notice]).to eq("Enrollment was successfully updated.")
    end
  end

  describe "DELETE #destroy" do
    before do
      sign_in(student)
    end

    it "destroys the enrollment" do
      enrollment
      expect {
        delete :destroy, params: { batch_id: batch.id, id: enrollment.id }
      }.to change(Enrollment, :count).by(-1)
    end

    it "redirects to root_path on success" do
      delete :destroy, params: { batch_id: batch.id, id: enrollment.id }
      expect(response).to redirect_to(root_path)
    end

    it "sets a flash notice after destroying" do
      delete :destroy, params: { batch_id: batch.id, id: enrollment.id }
      expect(flash[:notice]).to eq("Enrollment was successfully destroyed.")
    end

    it "renders the show template on failure" do
      allow_any_instance_of(Enrollment).to receive(:destroy).and_return(false)
      delete :destroy, params: { batch_id: batch.id, id: enrollment.id }
      expect(response).to render_template("show")
    end
  end

  describe "GET #pending" do
    before do
      sign_in(school_admin)
    end

    it "assigns @pending_enrollments" do
      get :pending
      expect(assigns(:pending_enrollments)).to eq(school_admin.school.enrollments)
    end

    it "renders the pending template" do
      get :pending
      expect(response).to render_template("pending")
    end
  end
end
