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
    context("logged out") do
      it "redirects to root path" do
        get :new
        expect(response).to redirect_to(root_path)
      end
    end

    context("logged in") do
      let(:user) { create(:user) }
      before do
        sign_in user
        get :new
      end
      it "assigns a new advert to @advert" do
        expect(assigns(:advert)).to be_a_new(Advert)
      end
      it "renders the new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "GET edit" do
    let(:advert) { create(:advert) }
    it "assigns a the correct advert to @advert" do
      get :edit, id: advert.id
      expect(assigns(:advert)).to eq(advert)
    end
    it "renders the edit template if correct user" do
      sign_in advert.user
      get :edit, id: advert.id
      expect(response).to render_template :edit
    end
    it "redirects to root if other user" do
      sign_in create(:user)
      get :edit, id: advert.id
      expect(response).to redirect_to root_path
    end
  end

  describe "POST create" do
    context "with no logged in user" do
      before { post :create, {advert: attributes_for(:advert)}}
      it "redirects to the root page" do
        expect(response).to redirect_to root_path
      end
      it "sets an error message" do
        expect(flash[:error]).to have_content(/daarvoor moet je ingelogd zijn/i)
      end
    end

    context "with valid params" do
      let(:user) { create(:user) }
      before { sign_in user }

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

    describe "adding linked images" do
      it "updates advert_id for those images" do
        sign_in create(:user)
        img1 = create(:image)
        img2 = create(:image)
        img3 = create(:image)
        expect(img1.advert_id).to be_nil
        post :create, {advert: attributes_for(:advert), img_ids: "1,2,3"}
        expect(img1.reload.advert_id).to eq(Advert.last.id)
        expect(img2.reload.advert_id).to eq(Advert.last.id)
        expect(img3.reload.advert_id).to eq(Advert.last.id)
      end
    end

    context "with invalid params" do
      let(:user) { create(:user) }
      before { sign_in user }

      def invalidPostRequest
        post :create, {:advert => {title: "", description: "invalid", price: "20" }}
      end

      it "doesn't persist a new advert" do
        expect{invalidPostRequest}.to_not change(Advert, :count)
      end

      it "rerenders the new template" do
        expect(invalidPostRequest).to render_template(:new)
      end

      it "displays error message" do
        invalidPostRequest
        expect(flash[:error]).to have_content(/je advertentie kon niet worden geplaatst/i)
      end
    end
  end

  describe "PUT update" do

    it "fails when no user logged in" do
      advert = create(:advert)
      put :update, {id: advert.to_param, advert: attributes_for(:advert)}
      expect(response).to redirect_to(root_path)
    end

    it "fails when logged in user is not the author" do
      advert = create(:advert)
      new_user = create(:user)
      sign_in new_user
      put :update, {id: advert.to_param, advert: attributes_for(:advert)}
      expect(response).to redirect_to(root_path)
    end

    describe "with valid params" do
      before(:each) do
        new_params = { title: "New Title", price: 200}
        @advert = create(:advert)
        sign_in @advert.user
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
        sign_in @advert.user
        put :update, {id: @advert.to_param, advert: new_params}
        @advert.reload
      end

      it "does not update the advert" do
        expect(@advert.title).to eq(attributes_for(:advert)[:title])
      end

      it "redirects the advert to the edit path" do
        expect(response).to redirect_to(edit_advert_path(@advert))
      end
    end

    describe "with img_ids" do
      it "updates the advert_ids of those images" do
        img1 = create(:image)
        img2 = create(:image)
        advert = create(:advert)
        sign_in advert.user
        put :update, {id: advert.to_param, advert: { title: "sth" }, img_ids: "1,2"}
        expect(img2.reload.advert_id).to eq(advert.id)
      end
    end
  end # end of PUT update

  describe "DELETE destroy" do

    let!(:advert) { create(:advert) }
    def destroyAdvert(advert)
      delete :destroy, {id: advert.to_param}
    end

    context "without author" do
      it "redirects to root when not logged in" do
        sign_in create(:user)
        destroyAdvert advert
        expect(response).to redirect_to root_path
      end
      it "doesn't delete the advert" do
        sign_in create(:user)
        expect{destroyAdvert(advert)}.to_not change(Advert, :count)
      end
    end

    context "with correct author" do
      before do
        @advert = create(:advert)
        sign_in @advert.user
      end
      it "deletes the advert from the database" do
        expect {destroyAdvert(@advert)}.to change(Advert, :count).by(-1)
      end

      it "displays a success message" do
        destroyAdvert(@advert)
        expect(flash[:success]).to have_content(/advertentie is verwijderd/i)
      end
    end
  end
end
