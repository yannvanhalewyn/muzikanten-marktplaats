require 'rails_helper'

RSpec.describe AdvertsController, type: :controller do


  describe "GET index" do
    let(:advert) { create(:advert) }
    before { get :index }

    it "assigns all adverts as @adverts" do
      expect(assigns(:adverts)).to eq([advert])
    end

    it "renders the index template" do
      expect(response).to render_template :index
    end
  end

  describe "GET show" do
    let(:advert) { create(:advert) }
    before { get :show, id: advert.id }
    it "assigns the correct advert to @advert" do
      expect(assigns(:advert)).to eq(advert)
    end

    it "renders the show template" do
      expect(response).to render_template :show
    end
  end

  describe "GET new" do
    before { get :new }
    it "assigns a new advert to @advert" do
      expect(assigns(:advert)).to be_a_new(Advert)
    end
    it "renders the new template" do
      expect(response).to render_template :new
    end
  end

  describe "GET edit" do
    let(:advert) { create(:advert) }
    before { get :edit, id: advert.id }
    it "assigns a the correct advert to @advert" do
      expect(assigns(:advert)).to eq(advert)
    end
    it "renders the edit template" do
      expect(response).to render_template :edit
    end
  end

  describe "POST create" do
    describe "with valid params" do
      def validPostRequest
        post :create, {:advert => attributes_for(:advert)}
      end

      it "creates a new advert" do
        expect{validPostRequest}.to change(Advert, :count).by(1)
      end

      it "redirects to the created advert page" do
        expect(validPostRequest).to redirect_to(advert_path(Advert.last))
      end

      it "displays success message" do
        validPostRequest
        expect(flash[:success]).to have_content(/advertentie is geplaatst/i)
      end
    end

    describe "with invalid params" do
      def invalidPostRequest
        post :create, {:advert => {title: "", description: "invalid", price: "20" }}
      end

      it "doesn't persist a new advert" do
        expect{invalidPostRequest}.to_not change(Advert, :count)
      end

      it "redirects to the new advert page" do
        expect(invalidPostRequest).to redirect_to(new_advert_path)
      end

      it "displays error message" do
        invalidPostRequest
        expect(flash[:error]).to have_content(/je advertentie kon niet worden geplaatst/i)
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      before(:each) do
        new_params = { title: "New Title", price: 200}
        @advert = create(:advert)
        put :update, {id: @advert.to_param, advert: new_params}
        @advert.reload
      end

      it "updates the advert" do
        expect(@advert.price).to eq(200)
        expect(@advert.title).to eq("New Title")
      end

      it "redirects to the advert" do
        expect(response).to redirect_to(advert_path(@advert))
      end
    end

    describe "with invalid params" do
      before(:each) do
        new_params = { title: "", price: 200}
        @advert = create(:advert)
        put :update, {id: @advert.to_param, advert: new_params}
        @advert.reload
      end

      it "does not update the advert" do
        expect(@advert.title).to eq(attributes_for(:advert)[:title])
      end

      it "redirects the advert to the edit path" do

      end
    end
  end

  describe "DELETE destroy" do
    def destroyAdvert(advert)
      delete :destroy, {id: advert.to_param}
    end
    it "deletes the advert from the database" do
      advert = create(:advert)
      expect {destroyAdvert(advert)}.to change(Advert, :count).by(-1)
    end

    it "displays a success message" do
      advert = create(:advert)
      destroyAdvert(advert)
      expect(flash[:success]).to have_content(/advertentie is verwijderd/i)
    end
  end

end
