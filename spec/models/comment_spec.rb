require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }
  #it { should belong_to(:user) }
  it { should belong_to(:advert) }
  it { expect(comment).to validate_presence_of(:content) }
  it { expect(comment).to validate_presence_of(:user_id) }
  it { expect(comment).to validate_presence_of(:advert_id) }

  describe "instantiation" do
    it "persists to the database" do
      expect(comment).to be_persisted
    end
  end
end
