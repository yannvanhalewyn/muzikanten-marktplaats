require 'rails_helper'

RSpec.feature "creating new adverts", type: :feature do

  describe "with logged out user" do
    before { visit new_advert_path }
    it "doesn't show a form and redirects to root path" do
      expect(current_path).to eq(root_path)
      #might have to specify selector a bit more
      expect(page).to_not have_selector('form#new_advert')
    end
    it "displays the error message" do
      expect(page).to have_content(/daarvoor moet je ingelogd zijn/i)
    end
  end

  describe "with logged in user" do

    let(:user) { create(:user) }
    before{ sign_in user }

    def visit_new_adverts_and_fill_in_form(options={})
      visit "/adverts"
      click_link "Plaats Advertentie!"
      expect(page).to have_selector('form#new_advert')

      options[:title] ||= "A valid title"
      options[:description] ||= "A valid description"
      options[:price] ||= 200
      fill_in "Titel", with: options[:title]
      fill_in "Beschrijving", with: options[:description]
      fill_in "Richtprijs", with: options[:price]
      click_button "Opslaan"
    end

    describe "shows a form" do
      it "with necessary fields" do
        visit new_advert_path
        expect(page).to have_selector('form#new_advert')
        expect(page).to have_selector('input#advert_title')
        expect(page).to have_selector('textarea#advert_description')
        expect(page).to have_selector('input#advert_price')
      end
    end

    describe "with valid params" do
      it "redirects to the created article" do
        visit_new_adverts_and_fill_in_form
        within("h1.advert-title") do
          expect(page).to have_content("A valid title")
        end
      end

      it "displays a success message" do
        visit_new_adverts_and_fill_in_form
        expect(page).to have_content(/je advertentie is geplaatst/i)
      end
    end

    describe "with invalid params" do
      it "desplays an error message when no title" do
        visit_new_adverts_and_fill_in_form({title: ""})
        expect(page).to have_content(/je advertentie kon niet worden geplaatst/i)
      end
    end
  end

end
