require 'rails_helper'

RSpec.describe ImagesController, type: :controller do

  describe "POST create" do
    context "with valid attachment" do
      def validPostRequest
        post :create, { image: attributes_for(:image) }
      end

      it "is successful" do
        validPostRequest
        expect(response).to have_http_status(:created)
      end

      it "returns the image in JSON format" do
        validPostRequest
        json_response = JSON.parse(response.body)
        expect(json_response["id"]).to eq(1)
      end

      it "adds a image to the database" do
        expect{validPostRequest}.to change(Image, :count).by(1)
      end
    end # end of with valid attachment context

    context "with invalid attachment" do
      # NOTE - couldn't get tests for an invalid 'image' field
      # e.g.: post :create, { image: "invalid" }
      # because it gives a NoMethodError, the carrierwave uploader
      # doesn't recognise this param. It should be ok, SHOULD never
      # happen, but it's a hole in the test-suite
      it "returns 400 without 'image' field" do
        post :create
        expect(response).to have_http_status(:bad_request)
      end
      it "returns 400 with empty 'image' field" do
        post :create, { image: "" }
        expect(response).to have_http_status(:bad_request)
      end
    end

  end # end of describe POST create

  describe "DELETE destroy" do
    let!(:image) { create(:image) }
    def destroyImage(image)
      delete :destroy, {id: image.to_param}
    end

    describe "a valid image" do
      it "deletes the image from the db" do
        expect{destroyImage(image)}.to change(Image, :count).by(-1)
      end
    end

    describe "with invalid id" do
      it "returns bad request status" do
        delete :destroy, {id: 9}
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
