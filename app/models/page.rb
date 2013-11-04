class Page < ActiveRecord::Base
  has_one :page_content, :class_name => "PageContent", :dependent => :destroy

  validates :url, :presence => true
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
