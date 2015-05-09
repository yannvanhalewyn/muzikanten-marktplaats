require 'rails_helper'

RSpec.feature "User Profile", type: :feature do
  let(:user) { create(:user) }

  describe "displays" do
    before { visit user_path(user) }
    it "the user's info" do
      expect(page).to have_content(user.name)
      expect(page).to have_selector("img[src$='#{user.image}']")
    end
    it "a link to the user's facebook profile" do
      expect(page).to have_selector("a[href$='#{user.fb_profile_url}']")
    end
    it "a message if no adverts" do
      expect(page).to have_content("#{user.first_name} heeft geen advertenties.")
    end
  end

  describe "lists" do
    before do
      @advert = user.adverts.create(attributes_for(:advert))
      visit user_path(user)
    end
    it "all the user's adds" do
      expect(page).to have_content(@advert.title)
      expect(page).to have_content(@advert.description)
    end
    it "the most recent add on top" do
      advert = user.adverts.create(attributes_for(:advert))
      older_advert = user.adverts.create(attributes_for(:advert))
      newer_advert = user.adverts.create(attributes_for(:advert))
      newer_advert.update_attribute(:created_at, 5.minutes.from_now)
      older_advert.update_attribute(:created_at, 5.minutes.ago)
      visit user_path user
      expect(newer_advert.title).to appear_before(advert.title)
      expect(advert.title).to appear_before(older_advert.title)
    end
    it "links to the user's adverts" do
      expect(page).to have_selector("a[href$='#{advert_path(@advert)}']")
    end
  end # End of describe lists
end
