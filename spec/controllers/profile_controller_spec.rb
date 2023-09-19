# spec/controllers/profile_controller_spec.rb

require 'rails_helper'

RSpec.describe ProfileController, type: :controller do
  let(:user) { create(:user) }

  before do
    sign_in(user)
  end

  describe "GET #show" do
    it "assigns @user" do
      get :show
      expect(assigns(:user)).to eq(user)
    end

    it "renders the show template" do
      get :show
      expect(response).to render_template("show")
    end
  end

  describe "GET #edit" do
    it "assigns @user" do
      get :edit
      expect(assigns(:user)).to eq(user)
    end

    it "renders the edit template" do
      get :edit
      expect(response).to render_template("edit")
    end
  end

  describe "PATCH #update" do
    context "with valid attributes" do
      it "updates the user's profile" do
        new_name = "New Name"
        patch :update, params: { profile: { name: new_name } }
        user.reload
        expect(user.name).to eq(new_name)
      end

      it "redirects to the profile show page" do
        patch :update, params: { profile: { name: user.name } }
        expect(response).to redirect_to(profile_url)
      end

      it "sets a flash notice after updating" do
        patch :update, params: { profile: { name: user.name } }
        expect(flash[:notice]).to eq("Profile updated successfully.")
      end
    end

    context "with invalid attributes" do
      it "does not update the user's profile" do
        patch :update, params: { profile: { email: nil } }
        user.reload
        expect(user.email).not_to be_nil
      end

      it "re-renders the edit template" do
        patch :update, params: { profile: { email: nil } }
        expect(response).to render_template("edit")
      end
    end
  end
end
