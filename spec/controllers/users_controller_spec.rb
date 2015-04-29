require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user)}
  describe "GET show" do
    before { get :show, id: user.to_param }

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "assigns the correct user as @user" do
      expect(assigns(:user)).to eq(user)
    end
  end

end
