require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:advert) { create(:advert) }

  describe "POST create" do

    context "logged in" do
      before { sign_in create(:user) }

      context "with valid params" do
        before do
          post :create, {
            :advert_id => advert.to_param,
            :comment => { content: "A comment" }
          }
        end

        it "assigns the correct @advert variable" do
          expect(assigns(:advert)).to eq(advert)
        end

        it "creates a new comment for the correct advert" do
          expect(Comment.count).to eq(1)
          expect(Comment.last.advert).to eq(advert)
          expect(Comment.last.content).to eq("A comment")
        end

        it "redirects to the advert path" do
          expect(response).to redirect_to(advert_path advert)
        end

        it "shows a success message" do
          expect(flash[:success]).to eq("Je comment was geplaatst.")
        end
      end # end of context with valid params

      context "with invalid params" do
        before do
          post :create, {
            :advert_id => advert.to_param,
            :comment => { content: "" }
          }
        end

        it "does not create a new comment" do
          expect(Comment.count).to eq(0)
        end

        it "redirects to the advert path" do
          expect(response).to redirect_to(advert_path advert)
        end

        it "shows an error message" do
          expect(flash[:error]).to eq("Je comment werd niet geplaatst.")
        end
      end # end of context with invalid params
    end # end of decribe logged in

    context "logged out" do
      it "redirects to the home page" do
        post :create, {
          advert_id: advert.to_param,
          comment: { content: "This is a valid comment."}
        }
        expect(response).to redirect_to(root_path)
      end
    end # end of context logged out

  end
end
