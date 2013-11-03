require 'factory_girl'

FactoryGirl.define do

  factory :context do |f|
    name 'test_context'
  end

  factory :scrapping_context, parent: :context, class: ScrappingContext do |f|
     page_scrapping_context_relations
     pages
     page_contents
  end
end
