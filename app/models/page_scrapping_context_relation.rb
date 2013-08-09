class PageScrappingContextRelation < ActiveRecord::Base
  belongs_to :page
  belongs_to :scrapping_context

  validates :page_id, uniqueness: { scope: :scrapping_context_id }

end