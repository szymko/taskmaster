class DownloadWorker

  def initialize(opts)
    @page_update = opts[:page_update]
    @crawler = opts[:crawler]
  end

  def perform(subset: Page, pattern: /.*/)
    @steps = ["Fetching urls...", "Getting pages...", "Scrapping urls...",
              "Inserting urls...", "Updating pages..."].reverse

    inform()
    pages = fetch(subset)

    inform()
    get(pages)

    inform()
    urls = scrap(pattern)

    inform()
    insert(urls)

    inform()
    update(pages)
  end

  private

  def fetch(subset)
    @page_update.fetch(subset: subset, number: 50)
  end

  def get(pages)
    @crawler.get(pages.map(&:url))
  end

  def scrap(pattern)
    @crawler.scrap(pattern)
  end

  def insert(urls)
    @page_update.insert(urls: urls)
  end

  def update(pages)
    @page_update.update(pages: pages, responses: @crawler.responses,
                        errors: @crawler.errors)
  end

  def inform()
    TaskLogger.log(level: :info, msg: @steps.pop)
  end
end
