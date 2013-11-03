class PageUpdate

  def fetch(**opts)
    subset = opts[:subset] || Page
    pages = []

    Page.transaction do
      pages = subset.waiting.limit(opts[:number]).lock
      pages.each { |p| p.mark_as("running") } if pages
    end

    pages
  end
#  def update_existing()
#    @processed_urls = @wiki_scrapper.responses.map { |r| URI.parse(r.url) }
#    @error_urls  = @wiki_scrapper.errors.map { |r| URI.parse(r.url) }
#
#    @pages.each do |page|
#      res = scrapping_result(page)
#
#      status = (scrapping_successful?(res) ? "success" : "error")
#      page.mark_as(status)
#
#      add_data_to_page(page, res)
#      page.save
#    end
#  end
#
#  def process_response(scrapper)
#    { success: scrapper.responses.map { |r| URI.parse(r.url) },
#      failure: scrapper.errors.map { |r| URI.parse(r.url) } }
#  end
#
#  p = PageUpdate.new()
#  pages = p.fetch(number: 10)
#  p.update(pages: pages, responses: responses, errors: errors)
#  p.insert(urls: new_urls)
#
end
