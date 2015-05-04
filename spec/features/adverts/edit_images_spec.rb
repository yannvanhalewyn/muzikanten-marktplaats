require 'rails_helper'

RSpec.feature "uploading advert images", type: :feature do

  before { sign_in create(:user) }

  describe "on a new advert form" do
    context "selecting a valid image" do
      it "creates an image" do
        visit new_advert_path
        path = File.join(Rails.root, 'spec/support/test-images/test1.jpg')
        expect(File).to exist(path)
        attach_file('new_image', path)
        expect(Image.count).to eq(1)
      end
    end # end of context selecting a valid image
  end # end of describe on a new advert form
end
