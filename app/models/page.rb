class Page < ActiveRecord::Base
  has_many :page_scrapping_context_relations
  has_many :scrapping_contexts, :through => :page_scrapping_context_relations
  has_many :contents, :class_name => "PageContent", :dependent => :destroy

  validates :url, :uniqueness => true
  scope :wiki, -> { where(Page.arel_table[:url].matches("%en.wikipedia%")) }

  STATUSES = %w{ waiting running success error }

  STATUSES.each do |s|
    class_eval <<-EVAL
      scope s.to_sym, -> { where(:status => s) }
    EVAL
  end

  def mark_as(status)
    raise ArgumentError unless STATUSES.member?(status.to_s)
    self.status = status.to_s
    save
  end
end