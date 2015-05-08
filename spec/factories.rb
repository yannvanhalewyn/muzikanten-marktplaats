FactoryGirl.define do

  factory :image do
    asset { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec', 'support', 'test-images', 'test1.jpg')) }
  end

  factory :user do
    provider "facebook"
    sequence(:uid) { |n| "#{n}"}
    sequence(:name) { |n| "Person_#{n}"}
    first_name "firstname"
    last_name "lastname"
    email "email@johndoe.com"
    image "http://www.image.com/link_to.jpg"
    fb_profile_url "http://www.facebook.com/john.doe"
    oauth_token "aoathtoken"
    oauth_expires_at 30.days.from_now
  end


  factory :comment do
    user
    advert
    content "MyText"
  end

  factory :advert do
    sequence :title do
      |n| "A valid advert title nr. #{n}"
    end
    description "A valid advert description"

    user
    factory :advert_with_price do
      price 200
    end
  end

end
