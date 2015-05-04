require 'rails_helper'

RSpec.feature "uploading advert images", type: :feature do

  self.use_transactional_fixtures = false
  before { page.driver.block_unknown_urls }

  describe "on a new advert form" do

    context "selecting a valid image" do
      it "creates an image", js: true do
        #sign_in build(:user)
        sign_in build(:user)
        visit new_advert_path
        path = File.join(Rails.root, 'spec/support/test-images/test1.jpg')
        expect(File).to exist(path)
        attach_file('add_image_field', path)

        sleep 1
        expect(Image.count).to eq(1)
      end
    end # end of context selecting a valid image
  end # end of describe on a new advert form
end
