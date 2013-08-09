require 'sidekiq'
require 'scrapper'

class ScrapperWorker

  def perform
    begin
      @wiki_scrapper = Scrapper::WikipediaScrapper.new(15)

      p "Fetching pages..."

      Page.transaction do
        @pages = Page.wiki.waiting.limit(50).lock(true)
        @pages.each { |p| p.mark_as("running")}
      end

      p "Scrappin'..."

      @wiki_scrapper.scrap(@pages.map(&:url))

      p "Updatin'..."

      update_existing_pages

      p "Insertin'..."
      insert_new_urls

    rescue Exception => e
      p "Rescuin'..."
      puts e
    end
  end

  def update_existing_pages
    @_processed_urls = @wiki_scrapper.responses.map { |r| r.url }
    @_error_urls  = @wiki_scrapper.errors.map { |r| r.url }

    @pages.each do |page|
      res = scrapping_result(page)

      status = (scrapping_successful?(res) ? "success" : "error")
      page.mark_as(status)

      add_data_to_page(page, res)
      page.save
    end
  end

  def insert_new_urls
    pages = []
    @wiki_scrapper.urls.each do |url|
      pages << Page.new(url: url, status: "waiting")
    end
    Page.import(pages)
  end

  def add_data_to_page(page, response)
    context = ScrappingContext.find_or_create_by(:name => "wikipedia")
    page.contexts << context

    return unless response.is_a?(Scrapper::Response)

    content = PageContent.new(status_code: response.status_code, headers: response.headers.to_s, body: response.body)
    page.contents << content
    context.page_contents << content
  end

  def scrapping_result(p)
    res = @wiki_scrapper.responses.find { |r| r.url == p.url }
  end

  def scrapping_successful?(res)
    res && res.is_a?(Scrapper::Response) && res.status_code == 200
  end
end