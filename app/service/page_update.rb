require 'uri'

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

  def insert(urls: [])
    pages = urls.map { |u| UrlUtility.add_slash(u) }.uniq.inject([]) do |p, u|
      p << Page.new(url: u) unless URI(u).relative?
      p
    end

    Page.import(pages)
  end

  def update(pages: [], responses: [], errors: [])
    pages.each do |p|
      res = responses.find { |r| p.url == r.url.to_s }
      res ? insert_response(p, res) : insert_error(p)
      p.save
    end
  end

  private

  def insert_result(page, result)
    if result.is_a?(Scrapper::RequestError) || result.nil?
      insert_error(page)
    else
      insert_response(page, result)
    end
  end

  def insert_response(page, response)
    page.mark_as("success")
    page.create_page_content(body: response.body,
                             status_code: response.status_code)
  end

  def insert_error(page)
    page.mark_as("error")
  end
#
#  p = PageUpdate.new()
#  pages = p.fetch(number: 10)
#  p.update(pages: pages, responses: responses, errors: errors)
#  p.insert(urls: new_urls)
#
end
