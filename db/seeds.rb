Url.create!(long_url:  "www.example.com",
            short_url: "example")

99.times do |n|
  long_url  = Faker::Internet.url
  short_url = Faker::Name.name[0..9]
  Url.create!(long_url:  long_url,
              short_url: short_url)
end
