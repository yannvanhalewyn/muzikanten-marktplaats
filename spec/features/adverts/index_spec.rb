require 'rails_helper'

RSpec.feature "displaying adverts", type: :feature do

  let!(:advert) { create(:advert) }

  before { visit adverts_path }

  it "shows all adverts" do
    within("#advert_#{advert.id}") do
      expect(page).to have_content(advert.title)
      expect(page).to have_content(advert.description)
    end
  end

  it "links to an advert" do
    within("#advert_#{advert.id}") do
      click_link advert.title
      expect(current_path).to eq(advert_path(advert))
    end

  end
end
