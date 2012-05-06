namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Example User",
                  email: "sbindra@example.com",
                  twittername: "@example",
                  facebookname: "example_fb",
                  password: "foobar",
                  password_confirmation: "foobar")
    admin.toggle!(:admin)
    
    99.times do |n|
      name = Faker::Name.name
      email = "example-#{n+1}@example.com"
      twitter = "@example-#{n+1}"
      facebook = "example-#{n+1}_fb"
      password = "password"
      User.create!(name: name,
                    email: email,
                    twittername: twitter,
                    facebookname: facebook,
                    password: password,
                    password_confirmation: password)
    end
    
    users = User.all(limit: 6)
    50.times do
      thebet = Faker::Lorem.sentence(5)
      users.each { |user| user.bets.create!(thebet: thebet) }
    end
  end
end