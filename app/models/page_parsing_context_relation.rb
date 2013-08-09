class PageScrappingContextRelation < ActiveRecord::Base
  belongs_to :page
  belongs_to :parsing_context

  validates :page_id, :presence => true
  validates :parsing_context_id, :presence => true
  validates :page_id, uniqueness: { scope: :parsing_context_id }

end