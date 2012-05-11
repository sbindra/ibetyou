FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    sequence(:twittername) { |n| "@person_#{n}" }
    sequence(:facebookname) { |n| "person_#{n}_fb" }
    password "foobar"
    password_confirmation "foobar"
    
    factory :admin do
      admin true
    end
  end
  
  factory :bet do
    thebet "Test Bet"
    user
  end

  factory :pick do
    pick true
    bet
    user
  end
end