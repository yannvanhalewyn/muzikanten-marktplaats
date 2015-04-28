require 'rails_helper'

RSpec.feature "Authentication", type: :feature do

  describe "singing in" do
    it "logs in" do
      user = create(:user)
      sign_in user
      within('div.user-widget') do
        expect(page).to have_content(/welkom #{user.name}/i)
      end
    end
    it "redirects to the page the user was on" do
      skip "Not implemented yet"
    end
  end
  describe "singing out" do
    it "logs out" do
      user = create(:user)
      sign_in user
      click_link "Uitloggen"
      expect(page).to have_content(/je bent uitgelogd/i)
    end

    it "redirects to the page the user was on" do
      skip "Not implemented yet"
    end
  end
end
