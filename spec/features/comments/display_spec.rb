require 'rails_helper'

RSpec.feature "displaying comments", type: :feature do

  describe "on advert page" do
    let(:comment) { create(:comment) }
    let(:advert) { comment.advert }
    let(:user) { comment.user }

    it "displays a comment" do
      visit advert_path advert
      within(".comments #comment_#{comment.id}") do
        expect(page).to have_content(comment.content)
      end
    end

    it "displays a comment's post in relative time" do
      comment.update_attribute(:created_at, 5.minutes.ago)
      visit advert_path advert
      within(".comments #comment_#{comment.id}") do
        expect(page).to have_content("5 minuten")
      end
    end

    it "displays the author's name and image" do
      comment.update_attribute(:created_at, 5.minutes.ago)
      visit advert_path advert
      within(".comments #comment_#{comment.id}") do
        expect(page).to have_content(user.name)
        expect(page).to have_selector("img[src$='#{user.image}']")
      end
    end

    it "has link to the author" do
      visit advert_path advert
      within(".comments #comment_#{comment.id}") do
        expect(page).to have_selector("a[href$='#{user_path(user)}']")
      end
    end

    it "displays comments in chronological order" do
      earlier_comment = advert.comments.create!(content: "Earlier Comment",
                                              created_at: 5.minutes.ago,
                                              user_id: 1)
      visit advert_path advert
      expect(page).to have_selector('li:first-child', text: earlier_comment.content)
      expect(page).to have_selector('li:nth-child(2)', text: comment.content)
    end

    it "displays a message if there are no comments" do
      clean_advert = create(:advert)
      visit advert_path clean_advert
      within ('.comment-section') do
        expect(page).to have_content("Er zijn nog geen reacties geplaatst op deze advertentie.")
      end
    end

    it "doesn't display a no-comments-message if there are comments" do
      visit advert_path advert
      within ('.comment-section') do
        expect(page).to_not have_content("Er zijn nog geen reacties geplaatst op deze advertentie.")
      end
    end
  end
end
