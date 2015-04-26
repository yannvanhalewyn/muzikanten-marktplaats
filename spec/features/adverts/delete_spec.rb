require 'rails_helper'

RSpec.feature "deleting adverts", type: :feature do

  it "is successful" do
    advert = create(:advert)
    visit advert_path(advert)
    expect{
      click_link "Verwijder advertentie"
    }.to change(Advert, :count).by(-1)
  end
end
