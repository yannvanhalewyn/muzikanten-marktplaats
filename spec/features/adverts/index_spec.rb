require 'rails_helper'

RSpec.feature "displaying adverts", type: :feature do


  describe "basic information" do
    let!(:advert) { create(:advert) }
    before { visit adverts_path }

    it "shows adverts ordered by most recent" do
      newer_advert = create(:advert)
      older_advert = create(:advert)
      newer_advert.update_attribute(:created_at, 5.minutes.from_now)
      older_advert.update_attribute(:created_at, 5.minutes.ago)
      visit adverts_path
      expect(newer_advert.title).to appear_before(advert.title)
      expect(advert.title).to appear_before(older_advert.title)
    end

    it "links to an advert" do
      within("#advert_#{advert.id}") do
        click_link advert.title
        expect(current_path).to eq(advert_path(advert))
      end
    end
  end

  describe "pagination" do
    before do
      user = build_stubbed(:user)
      15.times do
        create(:advert, user: user)
      end
      visit adverts_path
    end
    it "shows pagination" do
      within "#infinite-scrolling" do
        expect(page).to have_link("Volgende")
      end
    end
    it "goed to the next page on click" do
      within "#infinite-scrolling" do
        click_link("Volgende")
      end
      expect(page).to have_selector('.advert-listing', count: 5)
    end
  end

  describe "infinite scrolling", js: true do
    before do
      user = build_stubbed(:user)
      15.times do
        create(:advert, user: user)
      end
      page.driver.block_unknown_urls
      visit adverts_path
    end
    it "shows more adverts when scrolled to the bottom" do
      expect(page).to have_selector('.advert-listing', count: 10)
      page.execute_script "window.scrollBy(0,$(document).height())"
      expect(page).to have_selector('.advert-listing', count: 15)
    end
    it "doesn't show more adverts when not scrolled enough" do
      expect(page).to have_selector('.advert-listing', count: 10)
      page.execute_script "window.scrollBy(0,$(document).height()/5)"
      expect(page).to have_selector('.advert-listing', count: 10)
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

  describe "search field" do
    it "sends a get request with search params" do
      visit adverts_path
      fill_in "search", with: "searchterm"
      click_button "Zoek"
      expect(page).to have_content "Zoekresultaten voor 'searchterm'"
    end
  end
end
