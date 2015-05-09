require 'rails_helper'

RSpec.feature "uploading advert images", type: :feature, js: true, broken: false do

  # I just give up. Sometimes it works, sometimes it doesn't.
  # 10+ hrs is reason enough to just give in to the madness.

  before do
    page.driver.block_unknown_urls
    sign_in build_stubbed(:user)
    visit new_advert_path
    # In production, the actual file field is hidden. But then capybara can't find it to
    # attach any files. This allows capy to find it!
    page.driver.execute_script("$('#add_image_field').removeClass('hide')")
  end

  # I was having a REALLY hard time with synchronisation issues. I'm juggling
  # javascript, jquery file-upload, carrierwave, sqlite locking etc.. And each of those players
  # would give errors about some deep inconsistent system problems. I'm assuming I'm not stubbing
  # those calls out correctly, and I absolutely know sleeping in tests is unacceptable.
  # This is the only fix after 10+hours of trying that works in a consistent manner.
  # after do
  #   sleep 0.1
  # end

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
        Image.all.each { |i| puts i.asset.url }
        # this is a fucked up database_cleaner bug, it doesn't clean
        imageCount = Image.count
        attachFile('invalid.pdf')
        expect(Image.count).to eq(0)
      end
    end

  end # end of describe on a new advert form

  describe "submitting the form" do
    it "successfuly added all images to advert" do
      fill_in "Titel", with: "Valid Title"
      fill_in "Beschrijving", with: "A valid long description"
      attachFile 'test1.jpg'
      attachFile 'test2.jpg'
      click_button 'Opslaan'
      within '.advert-images' do
        expect(page.all('.advert-image').count).to eq(2)
      end
    end

    it "doesn't link images that were linked and removed" do
    end
  end
end
