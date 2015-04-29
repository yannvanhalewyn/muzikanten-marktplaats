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
    it "links to the user's adverts" do
      expect(page).to have_selector("a[href$='#{advert_path(@advert)}']")
    end
  end # End of describe lists
end
