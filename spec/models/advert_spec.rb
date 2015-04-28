require 'rails_helper'

RSpec.describe Advert, type: :model do

  let(:advert) { FactoryGirl.create(:advert) }
  it { should belong_to(:user) }

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

    it "is not sold" do
      expect(advert.sold?).to be_falsey
    end
  end

  describe "#sold?" do
    before do
      advert.update_attribute(:sold_at, Time.now)
    end

    it "returns true when sold_at is set" do
      expect(advert.sold?).to be_truthy
    end

    it "returns false when sold_at is reset to null" do
      advert.update_attribute(:sold_at, nil)
      expect(advert.sold?).to be_falsey
    end
  end

  describe "#toggle_sold!" do
    it "sets the sold_at value if not sold" do
      advert.toggle_sold!
      expect(advert.sold?).to be_truthy
    end

    it "sets the sold_at value to nil if sold" do
      advert.update_attribute(:sold_at, Time.now)
      advert.toggle_sold!
      expect(advert.sold?).to be_falsey
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
  end

end
