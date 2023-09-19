# spec/controllers/school_admins_controller_spec.rb

require 'rails_helper'

RSpec.describe SchoolAdminsController, type: :controller do
  let(:school) { create(:school) }
  let(:admin) { create(:user, school: school, role: 'admin') }
  let(:school_admin) { create(:user, school: school, role: 'school_admin') }

  before do
    sign_in(admin)
  end

  describe "GET #index" do
    it "renders the index template" do
      get :index, params: { school_id: school.id }
      expect(response).to render_template("index")
    end

    it "assigns @school_admins" do
      get :index, params: { school_id: school.id }
      expect(assigns(:school_admins)).to be_an(ActiveRecord::Relation)
    end
  end

  describe "GET #new" do
    it "renders the new template" do
      get :new, params: { school_id: school.id }
      expect(response).to render_template("new")
    end

    it "assigns a new @school_admin" do
      get :new, params: { school_id: school.id }
      expect(assigns(:school_admin)).to be_a_new(User)
    end
  end

  describe "GET #edit" do
    it "renders the edit template" do
      get :edit, params: { school_id: school.id, id: school_admin.id }
      expect(response).to render_template("edit")
    end

    it "assigns @school_admin" do
      get :edit, params: { school_id: school.id, id: school_admin.id }
      expect(assigns(:school_admin)).to eq(school_admin)
    end
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show, params: { school_id: school.id, id: school_admin.id }
      expect(response).to render_template("show")
    end

    it "assigns @school_admin" do
      get :show, params: { school_id: school.id, id: school_admin.id }
      expect(assigns(:school_admin)).to eq(school_admin)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      it "creates a new school admin" do
        expect {
          post :create, params: { school_id: school.id, school_admin: attributes_for(:user) }
        }.to change(User, :count).by(1)
      end

      it "redirects to the school admin show page" do
        post :create, params: { school_id: school.id, school_admin: attributes_for(:user) }
        expect(response).to redirect_to(school_school_admin_url(school, User.first))
      end
    end

    context "with invalid attributes" do
      it "does not create a new school admin" do
        expect {
          post :create, params: { school_id: school.id, school_admin: attributes_for(:user, email: nil) }
        }.not_to change(User, :count)
      end

      it "re-renders the new template" do
        post :create, params: { school_id: school.id, school_admin: attributes_for(:user, email: nil) }
        expect(response).to render_template("new")
      end
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the school admin" do
        new_name = "New School Admin Name"
        patch :update, params: { school_id: school.id, id: school_admin.id, school_admin: { name: new_name, description: school_admin.description } }
        school_admin.reload
        expect(school_admin.name).to eq(new_name)
      end

      it "redirects to the school admin show page" do
        patch :update, params: { school_id: school.id, id: school_admin.id, school_admin: { name: school_admin.name, description: school_admin.description } }
        expect(response).to redirect_to(school_school_admin_url(school, school_admin))
      end
    end

    context "with invalid attributes" do
      it "does not update the school admin" do
        patch :update, params: { school_id: school.id, id: school_admin.id, school_admin: { email: nil } }
        school_admin.reload
        expect(school_admin.email).not_to be_nil
      end

      it "re-renders the edit template" do
        patch :update, params: { school_id: school.id, id: school_admin.id, school_admin: { email: nil } }
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the school admin" do
      school_admin # Create the school admin
      expect {
        delete :destroy, params: { school_id: school.id, id: school_admin.id }
      }.to change(User, :count).by(-1)
    end

    it "redirects to school_admins_url after destruction" do
      delete :destroy, params: { school_id: school.id, id: school_admin.id }
      expect(response).to redirect_to(school_school_admins_url(school))
    end
  end
end
