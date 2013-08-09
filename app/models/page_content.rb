class PageContent < ActiveRecord::Base
  belongs_to :page
  belongs_to :scrapping_context

  validates :body, :presence => true
  validates :status_code, :presence => true
end