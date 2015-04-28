require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:adverts) }
  # let(:user) { create(:user) }
  # it { expect(user).to validate_presence_of(:name) }
end
