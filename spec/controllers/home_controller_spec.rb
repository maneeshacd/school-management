# spec/controllers/home_controller_spec.rb

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { create(:user, role: :admin) }

  before do
    sign_in(user)
  end

  describe "GET #show" do
    context "when the user is an admin" do
      it "redirects to schools_path" do
        get :show
        expect(response).to redirect_to(schools_path)
      end
    end

    context "when the user is not an admin" do
      it "redirects to home_path" do
        user.role = :school_admin
        user.save
        get :show
        expect(response).to redirect_to(home_path)
      end
    end
  end
end
