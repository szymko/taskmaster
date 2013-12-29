class BareTextStrategy

  def parse(body, opts = {})
    path = opts[:xpath] || '//body'
    text = Nokogiri::HTML(body).xpath(path).text()
    text.gsub(/\/\*\<\!.*/m, '')
  end

end
