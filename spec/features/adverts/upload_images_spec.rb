require 'rails_helper'

RSpec.feature "uploading advert images", type: :feature, js: true do

  before do
    page.driver.block_unknown_urls
    @user = create(:user)
    sign_in @user
    visit new_advert_path
    # In production, the actual file field is hidden. But then capybara can't find it to
    # attach any files. This allows capy to find it!
    page.driver.execute_script("$('#add_image_field').removeClass('hide')")
  end

  def attachFile filename
    path = File.join(Rails.root, 'spec/support/test-images', filename)
    expect(File).to exist(path)
    attach_file('add_image_field', path)
    wait_for_ajax
  end

  describe "on a new advert form" do
    context "selecting a valid image" do
      it "creates an image" do
        attachFile 'test1.jpg'
      end

      it "displays the image via #upload-template" do
        attachFile 'test1.jpg'
        within('#uploaded-images') do
          expect(page.all('.advert-image').count).to eq(1)
          expect(page).to have_content 'test1.jpg'
        end
      end
    end # end of context selecting a valid image

    context "selecting an invalid file type" do
      it "doesn't persist" do
        # this is a fucked up database_cleaner bug, it doesn't clean
        imageCount = Image.count
        attachFile('invalid.pdf')
        expect(Image.count).to eq(0)
      end
    end

  end # end of describe on a new advert form

  describe "submitting the form" do
    before do
      fill_in "Titel", with: "Valid Title"
      fill_in "Beschrijving", with: "A valid long description"
    end
    it "successfuly added all images to advert" do
      attachFile 'test1.jpg'
      attachFile 'test2.jpg'
      click_button 'Opslaan'
      within '.advert-images' do
        expect(page.all('.advert-image').count).to eq(2)
      end
    end
    it "doesn't link images that were linked and removed" do
      attachFile 'test1.jpg'
      attachFile 'test2.jpg'
      within "#advert_img_1" do
        click_button 'Verwijder'
      end
      click_button 'Opslaan'
      within '.advert-images' do
        expect(page.all('.advert-image').count).to eq(1)
      end
    end
  end # end of describe submitting the form

  describe "editing an advert's images" do
    before do
      @advert = create(:advert, user: @user)
      create(:image, advert: @advert)
      visit edit_advert_path @advert
    end

    it "deletes an images" do
      within "#advert_img_1" do
        find('.delete-button').click
        wait_for_ajax
      end
      expect(page.all('.advert-image').count).to eq(0)
    end

    it "adds a new image" do
      page.driver.execute_script("$('#add_image_field').removeClass('hide')")
      attachFile 'test1.jpg'
      expect(page.all('.advert-image').count).to eq(2)
      expect(page).to have_content 'test1.jpg'
    end

  end
end
