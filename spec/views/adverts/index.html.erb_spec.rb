require 'rails_helper'

describe "adverts/index" do

  before do
    allow(view).to receive(:current_user).and_return(nil)
    allow(view).to receive_messages(:will_paginate => nil)
  end

  it "displays the advert state if not for_sale" do
    assign(:adverts, [
      build_stubbed(:advert, state: "sold"),
      build_stubbed(:advert)
    ])
    render
    expect(rendered).to have_content /verkocht/i
    expect(rendered).to_not have_content /te koop/i
  end
end
