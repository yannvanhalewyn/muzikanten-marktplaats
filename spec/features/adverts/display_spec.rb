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

    it "a message when no price is specified" do
      expect(page).to have_content("Prijs is niet gespecifiëerd")
    end

    it "the correct price if specified" do
      advert.update_attribute(:price, 200)
      visit advert_path(advert)
      expect(page).to have_content(200)
    end

    it "the author's name and profile picture" do
      within '.seller-widget' do
        expect(page).to have_selector("img[src$='#{user.image}']")
        expect(page).to have_content(user.name)
      end
    end
  end

  context "the seller-widget" do
    let (:user) { advert.user }
    before { visit advert_path(advert) }
    it "links to the seller page" do
      within '.seller-widget' do
        expect(page).to have_selector("a[href$='#{user_path(user)}']")
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
