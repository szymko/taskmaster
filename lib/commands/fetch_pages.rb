class FetchPages

  def initialize(subset: Page,
                 number: TaskmasterConfig[:crawler][:fetch_limit])
    @subset = subset
    @number = number
  end

  def perform(**opts)
    pages = []

    Page.transaction do
      pages = @subset.waiting.limit(@number).lock
      pages.each { |p| p.mark_as("running") } if pages
    end

    { pages: pages }
  end

end
