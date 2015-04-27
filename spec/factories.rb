FactoryGirl.define do  factory :user do
    provider "MyString"
uid "MyString"
name "MyString"
first_name "MyString"
last_name "MyString"
email "MyString"
image "MyString"
fb_profile_url "MyString"
oauth_token "MyString"
oauth_expires_at "2015-04-27 22:02:19"
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
