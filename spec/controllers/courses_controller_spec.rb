# spec/controllers/courses_controller_spec.rb

require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  let(:school) { create(:school) }
  let(:school_admin) { create(:user, role: :school_admin, school: school) }
  let(:course) { create(:course, school: school) }

  before do
    sign_in(school_admin)
  end

  describe "GET #index" do
    it "assigns @courses" do
      get :index
      expect(assigns(:courses)).to eq(school.courses)
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "assigns @course" do
      get :show, params: { id: course.id }
      expect(assigns(:course)).to eq(course)
    end

    it "renders the show template" do
      get :show, params: { id: course.id }
      expect(response).to render_template("show")
    end
  end

  describe "GET #new" do
    it "assigns a new @course" do
      get :new
      expect(assigns(:course)).to be_a_new(Course)
    end

    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "GET #edit" do
    it "assigns @course" do
      get :edit, params: { id: course.id }
      expect(assigns(:course)).to eq(course)
    end

    it "renders the edit template" do
      get :edit, params: { id: course.id }
      expect(response).to render_template("edit")
    end
  end

  describe "POST #create" do
    it "creates a new course" do
      expect {
        post :create, params: { course: attributes_for(:course) }
      }.to change(Course, :count).by(1)
    end

    it "redirects to course_url on success" do
      post :create, params: { course: attributes_for(:course) }
      expect(response).to redirect_to(course_url(Course.last))
    end

    it "sets a flash notice after creating" do
      post :create, params: { course: attributes_for(:course) }
      expect(flash[:notice]).to eq("Course was successfully created.")
    end

    it "renders the new template on failure" do
      allow_any_instance_of(Course).to receive(:save).and_return(false)
      post :create, params: { course: attributes_for(:course) }
      expect(response).to render_template("new")
    end
  end

  describe "PATCH #update" do
    it "updates the course" do
      new_name = "New Course Name"
      patch :update, params: { id: course.id, course: { name: new_name } }
      course.reload
      expect(course.name).to eq(new_name)
    end

    it "redirects to course_url on success" do
      patch :update, params: { id: course.id, course: attributes_for(:course) }
      expect(response).to redirect_to(course_url(course))
    end

    it "sets a flash notice after updating" do
      patch :update, params: { id: course.id, course: attributes_for(:course) }
      expect(flash[:notice]).to eq("Course was successfully updated.")
    end

    it "renders the edit template on failure" do
      allow_any_instance_of(Course).to receive(:update).and_return(false)
      patch :update, params: { id: course.id, course: attributes_for(:course) }
      expect(response).to render_template("edit")
    end
  end

  describe "DELETE #destroy" do
    it "destroys the course" do
      course  # Ensure the course is created
      expect {
        delete :destroy, params: { id: course.id }
      }.to change(Course, :count).by(-1)
    end

    it "redirects to courses_url on success" do
      delete :destroy, params: { id: course.id }
      expect(response).to redirect_to(courses_url)
    end

    it "sets a flash notice after destroying" do
      delete :destroy, params: { id: course.id }
      expect(flash[:notice]).to eq("Course was successfully destroyed.")
    end

    it "renders the show template on failure" do
      allow_any_instance_of(Course).to receive(:destroy).and_return(false)
      delete :destroy, params: { id: course.id }
      expect(flash[:notice]).to eq("not deleted.")
    end
  end
end
