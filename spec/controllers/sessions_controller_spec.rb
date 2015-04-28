require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]
  end

  describe "#create" do
    context "with new user" do
      it "creates a new user" do
        expect {
          post :create, provider: :facebook
        }.to change(User, :count).by(1)
      end

      it "sets the session user_id" do
        expect(session[:user_id]).to be_nil
        post :create, provider: :facebook
        expect(session[:user_id]).to eq(1)
      end

      it "redirects to root" do
        post :create, provider: :facebook
        expect(response).to redirect_to(root_path)
      end

      it "sets flash success message" do
        post :create, provider: :facebook
        expect(flash[:success]).to have_content(/je bent succesvol ingelogd/i)
      end
    end

    context "when already logged in" do
      before { post :create, provider: :facebook }

      it "doesn't create a new user" do
        expect {
          post :create, provider: :facebook
        }.to change(User, :count).by(0)
      end
    end

    context "with existing user, but logged out" do
      before do
        post :create, provider: :facebook
        post :destroy
      end
      it "does not create a new user" do
        expect {
          post :create, provider: :facebook
        }.to change(User, :count).by(0)
      end
    end

    describe "#destroy" do
      before do
        post :create, provider: :facebook
        expect(session[:user_id]).to_not be_nil
      end
      it "removes the session's user id" do
        post :destroy
        expect(session[:user_id]).to be_nil
      end
    end

    describe "#failure" do
      before { post :failure }
      it "redirects to root" do
        expect(response).to redirect_to(root_path)
      end
      it "sets the error message" do
        expect(flash[:error]).to have_content(/er is een probleem opgetreden bij het inloggen/i)
      end
    end
  end


end
