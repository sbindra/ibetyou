FactoryGirl.define do
  factory :user do
    name     "Shamick Bindra"
    email    "sbindra@example.com"
    twittername "@bindrabindra"
    facebookname "sbindra_fb"
    password "foobar"
    password_confirmation "foobar"
  end
end