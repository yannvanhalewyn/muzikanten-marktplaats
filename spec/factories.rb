FactoryGirl.define do
  factory :user do
    provider "facebook"
    sequence(:uid) { |n| "#{n}"}
    sequence(:name) { |n| "Person_#{n}"}
    first_name "firstname"
    last_name "lastname"
    email "email@johndoe.com"
    image "http://www.image.com/link_to.jpg"
    fb_profile_url "http://www.facebook.com/"
    oauth_token "MyString"
    oauth_expires_at 30.days.from_now
  end


  factory :comment do
    user_id 1
    advert
    content "MyText"
  end

  factory :advert do
    title "A valid advert title"
    description "A valid advert description"

    factory :advert_with_price do
      price 200
    end
  end

end
