require 'rails_helper'

RSpec.feature "advert page", type: :feature do

  let!(:advert) { create(:advert) }

  describe "displays" do
    let (:user) { advert.user }
    before { visit advert_path(advert) }
    it "the correct advert" do
      expect(page).to have_content(advert.title)
      expect(page).to have_content(advert.description)
    end

    it "the images linked to the ad" do
      img = advert.images.create(attributes_for(:image))
      visit advert_path(advert)
      within '.advert-images' do
        expect(page.all('.advert-image').count).to eq(1)
        expect(page).to have_selector("img[src$='#{img.asset.medium.url}']")
      end
    end
  end

  context "when logged out" do
    before { visit advert_path(advert) }
    it "doensn't have an author-options section" do
      expect(page).to_not have_selector("#author-options")
    end
    it "doesn't show the edit/delete button" do
      expect(page).to_not have_selector(:link_or_button,
                                      text: /bewerk|verwijder/i )
    end
  end

  describe "when logged in" do
    context "as the author" do
      before do
        sign_in advert.user
        visit advert_path(advert)
      end
      it "has a author-options section" do
        expect(page).to have_selector("#author-options")
        expect(page).to have_content("Verkoper opties")
      end
      it "shows the edit and delete button" do
        expect(page).to have_selector(:link_or_button, text: /bewerk/i)
        expect(page).to have_selector(:link_or_button, text: /verwijder/i)
      end

      # ======
      # states
      # ======
      describe "states" do

        context "for_sale" do
          it "displays For Sale as span" do
            within "#author-options" do
              expect(page).to have_selector("span", text: /te koop/i)
              expect(page).to_not have_link("Te koop")
            end
          end

          it "links to reserve" do
            expect(page).to_not have_selector("span", text: /gereserveerd/i)
            within "#author-options" do
              click_link "Gereserveerd"
            end
            expect(page).to have_content("Je advertentie is gereserveerd")
          end

          it "links to sell" do
            expect(page).to_not have_selector("span", text: /verkocht/i)
            within "#author-options" do
              click_link "Verkocht"
            end
            expect(page).to have_content("Je advertentie is verkocht")
          end
        end # end of context for sale

        context "reserved" do
          before do
            advert.reserved!
            visit advert_path advert
          end
          it "displays Reserved as span" do
            within "#author-options" do
              expect(page).to have_selector("span", text: /gereserveerd/i)
              expect(page).to_not have_link("Gereserveerd")
            end
          end

          it "links to for_sale" do
            expect(page).to_not have_selector("span", text: /te koop/i)
            within "#author-options" do
              click_link "Te koop"
            end
            expect(page).to have_content("Je advertentie staat nu te koop")
          end

          it "links to sell" do
            expect(page).to_not have_selector("span", text: /verkocht/i)
            within "#author-options" do
              click_link "Verkocht"
            end
            expect(page).to have_content("Je advertentie is verkocht")
          end
        end # end of context reserved

        context "sold" do
          before do
            advert.sold!
            visit advert_path advert
          end
          it "displays Sold as span" do
            within "#author-options" do
              expect(page).to have_selector("span", text: /verkocht/i)
              expect(page).to_not have_link("Verkocht")
            end
          end

          it "links to for_sale" do
            expect(page).to_not have_selector("span", text: /te koop/i)
            within "#author-options" do
              click_link "Te koop"
            end
            expect(page).to have_content("Je advertentie staat nu te koop")
          end

          it "links to reserved" do
            expect(page).to_not have_selector("span", text: /gereserveerd/i)
            within "#author-options" do
              click_link "Gereserveerd"
            end
            expect(page).to have_content("Je advertentie is gereserveerd")
          end
        end # end of context sold
      end # end of describe states
    end # end of context as the author

    context "as another user" do
      it "doensn't have an author-options section" do
        sign_in create(:user)
        visit advert_path(advert)
        expect(page).to_not have_selector("#author-options")
        expect(page).to_not have_content("Verkoper opties")
      end
      it "doesn't show the edit/delete button" do
        sign_in create(:user)
        visit advert_path(advert)
        expect(page).to_not have_selector(:link_or_button,
                                        text: /bewerk|verwijder/i )
      end
    end
  end

end
