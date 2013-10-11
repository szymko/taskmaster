# require 'sidekiq'
require 'scrapper'
require 'uri'

class ScrapperWorker

  def perform
    begin
      @wiki_scrapper = Scrapper::Runner.new(async_no: 15)

      p "Fetchin' pages..."

      Page.transaction do
        @pages = Page.wiki.waiting.limit(50).lock(true)
        @pages.each { |p| p.mark_as("running")}
      end

      p "Scrappin'..."

      @wiki_scrapper.scrap(@pages.map(&:url)) { |u| u =~ /en\.wikipedia\.org\/wiki/ }

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
    @processed_urls = @wiki_scrapper.responses.map { |r| URI.parse(r.url) }
    @error_urls  = @wiki_scrapper.errors.map { |r| URI.parse(r.url) }

    @pages.each do |page|
      res = scrapping_result(page)

      status = (scrapping_successful?(res) ? "success" : "error")
      page.mark_as(status)

      add_data_to_page(page, res)
      page.save
    end
  end

  def insert_hosts
    robot_hosts = Robot.pluck(:host)
    received_hosts = (@processed_urls + @error_urls).map { |u| u.host }.uniq
    new_hosts = download_robots(received_hosts - robot_hosts)
    new_robots = []

    new_hosts.each { |host, files| new_robots << Robot.new(host: host, rules: files) }
    Robot.import(new_hosts)
  end

  def download_robots(hosts)
    robots = Scrapper::Robots.new
    robots.get_raw(hosts).files
  end

  def insert_new_urls
    pages = []
    @wiki_scrapper.urls.uniq.each do |url|
      pages << Page.new(url: url, status: "waiting")
    end
    Page.import(pages)
  end

  def add_data_to_page(page, response)
    context = ScrappingContext.find_or_create_by(:name => "wikipedia")
    page.scrapping_contexts << context

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