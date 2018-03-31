FactoryBot.define do
  factory :url do
    long_url { Faker::Internet.url}
  end
end