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

  it "shows adverts ordered by most recent" do
    newer_advert = create(:advert)
    older_advert = create(:advert)
    newer_advert.update_attribute(:created_at, 5.minutes.from_now)
    older_advert.update_attribute(:created_at, 5.minutes.ago)
    visit adverts_path
    expect(newer_advert.title).to appear_before(advert.title)
    expect(advert.title).to appear_before(older_advert.title)
  end

  it "Display's the advert's target price if present" do
    advert.update_attribute(:price, 30)
    visit adverts_path
    within("#advert_#{advert.id}") do
      expect(page).to have_content("30,00")
    end
  end

  it "Doesn't display anything if no price specified" do
    within("#advert_#{advert.id}") do
      expect(page).to_not have_content("€")
    end
  end

  it "Display's the adverts first image as a thumbnail" do
    advert.images.create(attributes_for(:image))
    visit adverts_path
    within("#advert_#{advert.id}") do
      expect(page).to have_selector("img[src$='#{advert.images.first.asset.thumb.url}']")
    end
  end

  it "Doesn't try to display an image if the ad has none" do
    within("#advert_#{advert.id}") do
      expect(page).to_not have_selector("img")
    end
  end

  it "display's the how long the advert has been on display" do
    advert.update_attribute(:created_at, 2.days.ago)
    visit adverts_path
    within("#advert_#{advert.id}") do
      expect(page).to have_content("2 dagen geleden")
    end
  end

  it "display's the number of comments there are on the adverts" do
    advert.comments.create(content: "A comment", user_id: 1)
    visit adverts_path
    within("#advert_#{advert.id}") do
      expect(page).to have_content("1 reactie(s)")
    end
  end

  it "display's a custom message if no comments" do
    within("#advert_#{advert.id}") do
      expect(page).to have_content("geen reacties")
    end
  end

  it "links to an advert" do
    within("#advert_#{advert.id}") do
      click_link advert.title
      expect(current_path).to eq(advert_path(advert))
    end
  end

  context "logged out" do
    it "does not display link to new advert" do
      expect(page).to_not have_selector(:link_or_button,
                                        text: /plaats/i)
    end
  end

  context "logged in" do
    let(:user) { create(:user) }
    before{sign_in user}
    it "displays link to new advert" do
      expect(page).to have_selector(:link_or_button,
                                   text: /plaats advertentie/i)
    end
  end
end
