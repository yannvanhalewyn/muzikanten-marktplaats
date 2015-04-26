require 'rails_helper'

RSpec.feature "creating new adverts", type: :feature do

  def create_advert(options={})
    visit "/adverts"
    click_link "Plaats Advertentie"
    expect(page).to have_selector('form')

    options[:title] ||= "A valid title"
    options[:description] ||= "A valid description"
    options[:price] ||= 200
    fill_in "Titel", with: options[:title]
    fill_in "Beschrijving", with: options[:description]
    fill_in "Richt Prijs", with: options[:price]
    click_button "Opslaan"
  end

  describe "shows a form" do
    it "with necessary fields" do
      visit new_advert_path
      expect(page).to have_selector('form')
      expect(page).to have_selector('input#advert_title')
      expect(page).to have_selector('textarea#advert_description')
      expect(page).to have_selector('input#advert_price')
    end
  end

  describe "with valid params" do
    it "redirects to the created article" do
      create_advert
      within("h1.advert-title") do
        expect(page).to have_content("A valid title")
      end
    end

    it "displays a success message" do
      create_advert
      expect(page).to have_content(/je advertentie is geplaatst/i)
    end
  end

  describe "with invalid params" do
    it "desplays an error message when no title" do
      create_advert({title: ""})
      expect(page).to have_content(/je advertentie kon niet worden geplaatst/i)
    end
  end

end
