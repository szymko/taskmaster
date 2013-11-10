class BareTextStrategy
  def parse(body, opts = {})
    path = opts[:xpath] || '//body'
    Nokogiri::HTML(body).xpath(path).text()
  end
end
