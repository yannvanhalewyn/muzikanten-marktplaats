require 'rails_helper'

RSpec.feature "creating comments", type: :feature do

  let(:advert) { create(:advert) }

  context "signed in" do
    before do
      sign_in advert.user
      visit advert_path advert
    end

    it "shows a textarea for new comments" do
      within '.comment-section' do
        expect(page).to have_selector('textarea#comment_content')
      end
    end

    describe "with valid content" do
      it "is successful" do
        fill_in "comment_content", with: "This is a comment"
        click_button "Plaats Comment"
        expect(page).to have_content(/je comment was geplaatst/i)
      end
    end

    describe "with invalid content" do
      it "is not successful" do
        fill_in "comment_content", with: ""
        click_button "Plaats Comment"
        expect(page).to have_content(/je comment werd niet geplaatst/i)
      end
    end
  end # end of context signed in

  context "signed out" do
    it "doesn't show a textarea for new comments" do
      visit advert_path advert
      within '.comment-section' do
        expect(page).to_not have_selector('textarea#comment_content')
      end
    end
    it "displays a message telling user he needs to sign in" do
      visit advert_path advert
      within '.comment-section' do
        expect(page).to have_content(/je moet ingelogd zijn om een comment te plaatsen/i)
      end
      
    end
  end
end
