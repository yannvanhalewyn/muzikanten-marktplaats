require 'rails_helper'

RSpec.feature "editing existing adverts", type: :feature do

  before do
    @advert = create(:advert)
    sign_in @advert.user
    visit advert_path(@advert)
    click_link "Bewerk Advertentie"

  end

  def edit_advert(options={})
    options[:title] ||= "A valid title"
    options[:description] ||= "A valid description"
    options[:price] ||= 200
    fill_in "Titel", with: options[:title]
    fill_in "Beschrijving", with: options[:description]
    fill_in "Richtprijs", with: options[:price]
    click_button "Opslaan"
  end

  describe "with valid params" do
    it "redirects to the advert's show template" do
      edit_advert
      expect(current_path).to eq(advert_path(@advert))
    end

    it "shows a success message" do
      edit_advert
      expect(page).to have_content(/je advertentie is bewerkt/i)
    end
  end

  describe "with no title content" do
    it "redirects to the edit page" do
      edit_advert title: ""
      expect(current_path).to eq(edit_advert_path(@advert))
    end

    it "shows an error message" do
      edit_advert title: ""
      expect(page).to have_content(/Je advertentie kon niet worden bewerkt/i)
    end
  end

  describe "with invalid title" do
    it "redirects to the edit page" do
      edit_advert title: "la"
      expect(current_path).to eq(edit_advert_path(@advert))
    end

    it "shows an error message" do
      edit_advert title: "la"
      expect(page).to have_content(/Je advertentie kon niet worden bewerkt/i)
    end
  end
end
