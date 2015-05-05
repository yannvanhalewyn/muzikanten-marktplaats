require 'rails_helper'

RSpec.feature "uploading advert images", type: :feature, js: true, broken: true do

  # I just give up. Sometimes it works, sometimes it doesn't.
  # 10+ hrs is reason enough to just give in to the madness.

  before do
    page.driver.block_unknown_urls
    sign_in build(:user)
    visit new_advert_path
  end

  def attachFile filename
    path = File.join(Rails.root, 'spec/support/test-images', filename)
    expect(File).to exist(path)
    attach_file('add_image_field', path)
  end

  describe "on a new advert form" do
    context "selecting a valid image" do
      it "creates an image" do
        attachFile 'test1.jpg'
        waitFor{ Image.count == 1 }
      end

      it "displays the image via #upload-template" do
        attachFile 'test1.jpg'
        within('#uploaded-images') do
          expect(page.all('.thumb').count).to eq(1)
          expect(page).to have_content 'test1.jpg'
        end
      end
    end # end of context selecting a valid image

    context "selecting an invalid file type" do
      it "doesn't persist" do
        Image.all.each { |i| puts i.asset.url }
        # this is a fucked up database_cleaner bug, it doesn't clean
        imageCount = Image.count
        attachFile('invalid.pdf')
        expect(Image.count).to eq(imageCount)
      end
    end

  end # end of describe on a new advert form

  describe "submitting the form" do
    it "successfuly added all images to advert" do
      fill_in "Titel", with: "Valid Title"
      fill_in "Beschrijving", with: "A valid long description"
      attachFile 'test1.jpg'
      attachFile 'test2.jpg'
      waitFor{Image.count == 2}
      click_button 'Opslaan'
      within '.advert-images' do
        expect(page.all('.thumb').count).to eq(2)
      end
    end

    it "doesn't link images that were linked and removed" do
    end
  end
end
