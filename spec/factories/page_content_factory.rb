require 'factory_girl'

FactoryGirl.define do
  factory :page_content do |f|
    body "<html><head></head><body>hello!</body></html>"
    status_code "200"

    page
    scrapping_context
  end
end
