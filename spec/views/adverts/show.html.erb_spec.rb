require "rails_helper"

describe "adverts/show" do

  before do
    allow(view).to receive(:current_user).and_return(nil)
  end

  it "displays the advert title and description" do
    assign(:advert, build_stubbed(:advert))
    render
    expect(rendered).to have_content("A valid advert title nr. 1")
    expect(rendered).to have_content("A valid advert description")
  end

  it "displays a message when no price is specified" do
    assign(:advert, build_stubbed(:advert))
    render
    expect(rendered).to have_content("Prijs is niet gespecifiëerd")
  end

  it "displays the correct if specified" do
    assign(:advert, build_stubbed(:advert, price: 200))
    render
    expect(rendered).to have_content(200)
  end

  it "displays the author's name and profile picture" do
    user = build_stubbed(:user)
    assign(:advert, build_stubbed(:advert, user: user))
    render
    expect(rendered).to have_selector("img[src$='#{user.image}']")
    expect(rendered).to have_content(user.name)
  end

  it "has a link to the seller page" do
    user = build_stubbed(:user)
    assign(:advert, build_stubbed(:advert, user: user))
    render
    expect(rendered).to have_selector("a[href$='#{user_path(user)}']")
  end
end
