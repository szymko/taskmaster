class PageContent < ActiveRecord::Base
  belongs_to :page

  validates :body, :presence => true
  validates :status_code, :presence => true

  scope :not_published, -> { PageContent.where(published: false) }
end
