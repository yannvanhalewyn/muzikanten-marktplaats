FactoryGirl.define do

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
