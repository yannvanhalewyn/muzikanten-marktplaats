require 'rails_helper'

describe "adverts/index" do

  before do
    allow(view).to receive(:current_user).and_return(nil)
    allow(view).to receive_messages(:will_paginate => nil)
  end

  describe "basic information" do
    before do
      @adverts = [
        build_stubbed(:advert, state: "sold"),
        build_stubbed(:advert)
      ]
      assign(:adverts, @adverts)
    end

    it "shows all adverts" do
      render
      advert = @adverts.first
      expect(rendered).to have_content(advert.title)
      expect(rendered).to have_content(advert.description)
      advert = @adverts.last
      expect(rendered).to have_content(advert.title)
      expect(rendered).to have_content(advert.description)
    end
  end

  describe "advert listing" do
    let(:advert) { build_stubbed(:advert) }

    it "displays the advert's title" do
      render partial: "advert", locals: { advert: advert }
      expect(rendered).to have_content(advert.title)
    end

    it "displays the advert's description" do
      render partial: "advert", locals: { advert: advert }
      expect(rendered).to have_content(advert.description)
    end

    it "display's the advert's target price if present" do
      advert.price = 30
      render partial: "advert", locals: { advert: advert }
      expect(rendered).to have_content("30,00")
    end

    it "Doesn't display anything if no price specified" do
      render partial: "advert", locals: { advert: advert }
      expect(rendered).to_not have_content("€")
    end

    it "Display's the adverts first image as a thumbnail" do
      advert.images.build(attributes_for(:image))
      render partial: "advert", locals: { advert: advert }
      url = advert.images.first.asset.thumb.url
      expect(rendered).to have_selector("img[src$='#{url}']")
    end

    it "Doesn't try to display an image if the ad has none" do
      render partial: "advert", locals: { advert: advert }
      expect(rendered).to_not have_selector("img")
    end

    it "display's the how long the advert has been on display" do
      advert = create(:advert)
      advert.update_attribute(:created_at, 2.days.ago)
      render partial: "advert", locals: { advert: advert }
      expect(rendered).to have_content("2 dagen geleden")
    end

    it "display's the number of comments there are on the adverts" do
      advert.comments.create(content: "A comment", user_id: 1)
      render partial: "advert", locals: { advert: advert }
      expect(rendered).to have_content("1 reactie(s)")
    end

    it "display's a custom message if no comments" do
      render partial: "advert", locals: { advert: advert }
      expect(rendered).to have_content("geen reacties")
    end
  end

  # it "displays the advert state if not for_sale" do
  #   expect(rendered).to have_content /verkocht/i
  #   expect(rendered).to_not have_content /te koop/i
  # end
end
