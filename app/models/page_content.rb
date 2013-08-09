class PageContent < ActiveRecord::Base
  belongs_to :page
  belongs_to :scrapping_context
end