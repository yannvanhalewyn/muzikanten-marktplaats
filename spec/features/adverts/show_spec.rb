require 'rails_helper'

RSpec.feature "advert page", type: :feature do

  let!(:advert) { create(:advert) }
  before { visit advert_path(advert) }

  it "shows the correct advert" do
    expect(page).to have_content(advert.title)
    expect(page).to have_content(advert.description)
  end

  describe "price tag" do
    it "displays a message when no price is specified" do
      expect(page).to have_content("Prijs is niet gespecifiëerd")
    end

    it "displays the correct price if specified" do
      advert.update_attribute(:price, 200)
      visit advert_path(advert)
      expect(page).to have_content(200)
    end
  end
end
