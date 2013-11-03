require 'factory_girl'

FactoryGirl.define do

  sequence :url do |n|
    "http://www.example.com/#{n}"
  end

  factory :page do
    url
  end
end
