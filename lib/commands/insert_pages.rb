require 'uri'

class InsertPages

  def perform(**opts)
    uniform_urls = opts[:urls].map { |u| uniformize_url(u) }

    pages = uniform_urls.uniq.inject([]) { |p, u|
      p << Page.new(url: u) unless URI(u).relative?
      p
    }

    pages.each { |p| p.mark_as("waiting") }

    { imported: Page.import(pages) }
  end

  private

  def uniformize_url(u)
    UrlUtility.add_slash(UrlUtility.remove_fragment(u))
  end
end
