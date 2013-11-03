require 'factory_girl'

FactoryGirl.define do
  factory :page_scrapping_context_relation do |f|
    page
    scrapping_context
  end
end
