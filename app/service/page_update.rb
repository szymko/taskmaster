require 'uri'

class PageUpdate

  def fetch(**opts)
    subset = opts[:subset] || Page
    number = opts[:number] || TaskmasterConfig[:crawler][:fetch_limit]
    pages = []

    Page.transaction do
      pages = subset.waiting.limit(number).lock
      pages.each { |p| p.mark_as("running") } if pages
    end

    pages
  end

  def insert(urls: [])
    uniform_urls = urls.map { |u| UrlUtility.add_slash(UrlUtility.remove_fragment(u)) }
    pages = uniform_urls.uniq.inject([]) do |p, u|
      p << Page.new(url: u) unless URI(u).relative?
      p
    end

    pages.map { |p| p.mark_as("waiting") }

    Page.import(pages)
  end

  def update(pages: [], responses: [], errors: [])
    pages.each do |p|
      res = responses.find { |r| p.url == r.url.to_s }
      success?(res) ? insert_response(p, res) : insert_error(p, res)
      p.save
    end
  end

  private

  def insert_response(page, response)
    page.mark_as("success")
    page.create_page_content(body: response.body,
                             status_code: response.status_code)
  end

  def insert_error(page, response)
    status_code = response && response.status_code
    msg = "Page update error with url: #{page.url} "\
           "and status_code: #{status_code}."

    page.mark_as("error")
    TaskLogger.log(level: :warn, msg: msg)
  end

  def success?(response)
    response && (response.status_code.to_s =~ /(1|2|3)\d{2}/)
  end
#
#  p = PageUpdate.new()
#  pages = p.fetch(number: 10)
#  p.update(pages: pages, responses: responses, errors: errors)
#  p.insert(urls: new_urls)
#
end
