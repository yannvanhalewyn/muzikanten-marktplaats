FactoryGirl.define do  

  factory :advert do
    title "A valid advert title"
    description "A valid advert description"

    factory :advert_with_price do
      price 200
    end
  end

end
