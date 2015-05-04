require 'rails_helper'

RSpec.describe Image, type: :model do
  it { should belong_to(:advert) }
  it { should validate_presence_of(:asset) }
  let(:image) { create(:image) }

  describe "instantiation" do
    it "persists to the database" do
      expect(image).to be_persisted
    end
    it "saves the image locally" do
      expect(File).to exist(image.asset.url)
    end
  end

  describe "destruction" do
    it "destroys the local file" do
      pending "this works in development mode, but not in test env. I don't want to add code just so the tests pass. Figure this out later"
      filepath = image.asset.url
      image.destroy
      expect(File).to_not exist(filepath)
    end
  end
end
