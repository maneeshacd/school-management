# spec/controllers/schools_controller_spec.rb

require 'rails_helper'

RSpec.describe SchoolsController, type: :controller do
  let(:user) { create(:user, role: :admin) }
  let(:school) { create(:school) }
  let(:schools) { create_list(:school, 10)}

  before do
    sign_in(user)
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "assigns @schools" do
      get :index
      expect(assigns(:schools).to_a).to be_an(Array)
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, params: { id: school.id }
      expect(response).to render_template("show")
    end

    it "assigns @school" do
      get :show, params: { id: school.id }
      expect(assigns(:school)).to eq(school)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template("new")
    end

    it "assigns a new @school" do
      get :new
      expect(assigns(:school)).to be_a_new(School)
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { id: school.id }
      expect(response).to render_template("edit")
    end

    it "edits existing @school" do
      get :edit, params: { id: school.id }
      expect(assigns(:school)).to eq(school)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new school" do
        expect {
          post :create, params: { school: attributes_for(:school) }
        }.to change(School, :count).by(1)
      end

      it "redirects to the school show page" do
        post :create, params: { school: attributes_for(:school) }
        expect(response).to redirect_to(school_path(School.first))
      end
    end

    context "with invalid attributes" do
      it "does not create a new school" do
        expect {
          post :create, params: { school: attributes_for(:school, name: nil) }
        }.not_to change(School, :count)
      end

      it "re-renders the new template" do
        post :create, params: { school: attributes_for(:school, name: nil) }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the school" do
        new_name = "New School Name"
        patch :update, params: { id: school.id, school: { name: new_name, description: school.description } }
        school.reload
        expect(school.name).to eq(new_name)
      end

      it "redirects to the school show page for admin user" do
        allow(user).to receive(:admin?).and_return(true)
        patch :update, params: { id: school.id, school: { name: school.name, description: school.description } }
        expect(response).to redirect_to(school_path(school))
      end

      it "redirects to the home page for school admin user" do
        user.role = :school_admin
        user.save
        sign_in(user)
        patch :update, params: { id: school.id, school: { name: school.name, description: school.description } }
        expect(response).to redirect_to(home_path)
      end
    end

    context "with invalid attributes" do
      it "does not update the school" do
        patch :update, params: { id: school.id, school: { name: nil, description: school.description } }
        school.reload
        expect(school.name).not_to be_nil
      end

      it "re-renders the edit template" do
        patch :update, params: { id: school.id, school: { name: nil, description: school.description } }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the school" do
      school
      expect {
        delete :destroy, params: { id: school.id }
      }.to change(School, :count).by(-1)
    end

    it "redirects to schools_url after destruction" do
      delete :destroy, params: { id: school.id }
      expect(response).to redirect_to(schools_url)
    end

    it "sets a flash notice after destruction" do
      delete :destroy, params: { id: school.id }
      expect(flash[:notice]).to eq("School was successfully destroyed.")
    end
  end

  describe "GET #home" do
    before do
      user.role = :school_admin
      user.school = school
      user.save
      sign_in(user)
    end
    it "renders the home template" do
      get :home
      expect(response).to render_template("home")
    end

    it "assigns @school" do
      get :home
      expect(assigns(:school)).to eq(user.school)
    end
  end

  describe "GET #home_edit" do
    before do
      user.role = :school_admin
      user.school = school
      user.save
      sign_in(user)
    end
    it "renders the home_edit template" do
      get :home_edit
      expect(response).to render_template("home_edit")
    end

    it "assigns @school" do
      get :home_edit
      expect(assigns(:school)).to eq(user.school)
    end
  end

end
