require 'rails_helper'

RSpec.feature "creating comments", type: :feature do

  let(:advert) { create(:advert) }
  before { visit advert_path advert }

  it "shows a textarea for new comments" do
    expect(page).to have_selector('textarea#comment_content')
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
end
