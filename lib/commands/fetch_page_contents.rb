class FetchPageContents
  def initialize(limit: 50)
    @limit = limit
  end

  def perform(**opts)
    { page_contents: PageContent.not_published.includes(:page).limit(@limit) }
  end
end
