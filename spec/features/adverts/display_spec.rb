require 'rails_helper'

RSpec.feature "advert page", type: :feature do

  let!(:advert) { create(:advert) }

  describe "displays" do
    let (:user) { advert.user }
    before { visit advert_path(advert) }
    it "the correct advert" do
      expect(page).to have_content(advert.title)
      expect(page).to have_content(advert.description)
    end

    it "the images linked to the ad" do
      img = advert.images.create(attributes_for(:image))
      visit advert_path(advert)
      within '.advert-images' do
        expect(page.all('.advert-image').count).to eq(1)
        expect(page).to have_selector("img[src$='#{img.asset.medium.url}']")
      end
    end
  end

  context "when logged out" do
    before { visit advert_path(advert) }

    it "doesn't show the edit/delete button" do
      expect(page).to_not have_selector(:link_or_button,
                                      text: /bewerk|verwijder/i )
    end
  end

  describe "when logged in" do
    context "as the author" do
      it "shows the edit and delete button" do
        sign_in advert.user
        visit advert_path(advert)
        expect(page).to have_selector(:link_or_button, text: /bewerk/i)
        expect(page).to have_selector(:link_or_button, text: /verwijder/i)
      end
    end

    context "as another user" do
      it "doesn't show the edit/delete button" do
        sign_in create(:user)
        visit advert_path(advert)
        expect(page).to_not have_selector(:link_or_button,
                                        text: /bewerk|verwijder/i )
      end
    end
  end

end
