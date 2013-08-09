class PageParsing < ActiveRecord::Base
  belongs_to :page
  belongs_to :parsing_context

  validates :document, :presence => true
end