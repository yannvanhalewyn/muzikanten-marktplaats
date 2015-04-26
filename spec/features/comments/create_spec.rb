require 'rails_helper'

RSpec.feature "creating comments", type: :feature do

  let(:advert) { create(:advert) }
  it "shows a textarea for new comments" do
    visit advert_path advert 
    expect(page).to have_selector('textarea.new-comment')
  end
end
