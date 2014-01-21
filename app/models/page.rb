class Page < ActiveRecord::Base
  has_many :page_contents, :class_name => "PageContent", :dependent => :destroy

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

  def page_content
    page_contents.first
  end

  def page_content=(val)
    page_contents.first = val
  end

  def create_page_content(attrs)
    page_contents << PageContent.new(attrs)
    save
  end
end
