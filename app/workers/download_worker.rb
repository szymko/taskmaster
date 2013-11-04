class DownloadWorker

  def initialize(page_update, crawler)
    @page_update = page_update
    @crawler = crawler
  end

  def perform(subset: Page, pattern: /.*/)
    pages = @page_update.fetch(subset: subset, number: 50)
    @crawler.get(pages.map(&:url))
    urls = @crawler.scrap(pattern)

    @page_update.insert(urls: urls)
    @page_update.update(pages: pages, responses: @crawler.responses,
                        errors: @crawler.errors)
  end
end
