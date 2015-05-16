require 'rails_helper'

RSpec.describe Advert, type: :model do

  let(:advert) { create(:advert) }
  it { should belong_to(:user) }
  it { should have_many(:images) }
  it { should have_searchable_field(:title) }
  it { should have_searchable_field(:description) }

  describe "instantiation" do
    it "persists to the database" do
      expect(advert).to be_persisted
    end

    it "fails without title" do
      expect(advert).to validate_presence_of(:title)
    end

    it "fails without user_id" do
      expect(advert).to validate_presence_of(:user_id)
    end

    it "fails with to short title" do
      advert = Advert.create(title: "SH", description: "A valid description")
      expect(advert).to_not be_valid
    end

    it "fails without description" do
      expect(advert).to validate_presence_of(:description)
    end

    it "fails with to short description" do
      advert = Advert.create(title: "A valid Title", description: "ah")
      expect(advert).to_not be_valid
    end

    it "is for_sale by default" do
      expect(advert.state).to eq("for_sale")
    end
  end

  describe "states" do
    it "#for_sale?" do
      expect(advert.for_sale?).to be_truthy
      advert.update_attribute(:state, "not_for_sale")
      expect(advert.for_sale?).to be_falsey
    end
    it "#sold?" do
      expect(advert.sold?).to be_falsey
      advert.update_attribute(:state, "sold")
      expect(advert.sold?).to be_truthy
    end
    it "#reserved?" do
      expect(advert.reserved?).to be_falsey
      advert.update_attribute(:state, "reserved")
      expect(advert.reserved?).to be_truthy
    end
    it "#for_sale!" do
      advert.update_attribute(:state, "not_for_sale")
      advert.for_sale!
      expect(advert.state).to eq("for_sale")
    end
    it "#sold!" do
      advert.sold!
      expect(advert.state).to eq("sold")
    end
    it "#reserved!" do
      advert.reserved!
      expect(advert.state).to eq("reserved")
    end
  end

  describe "#destroy" do
    it "destroys all related comments" do
      comment = advert.comments.create(content: "A valid comment", user_id: 1)
      expect(comment).to be_persisted
      advert.destroy
      expect(comment).to_not be_persisted
    end

    it "doesn't destroy other comments" do
      othercomment = create(:comment)
      advert.destroy
      expect(othercomment).to be_persisted
    end

    it "destroys all related images" do
      image = advert.images.create(attributes_for(:image))
      advert.destroy
      expect(image).to_not be_persisted
    end

    it "doesn't destroy  unrelated images" do
      otherImage = create(:image)
      advert.destroy
      expect(otherImage).to be_persisted
    end
  end

end
