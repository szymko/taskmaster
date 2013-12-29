class ObligatoryOptionalStrategy

  def initialize(opts)
    @obligatory_path = opts[:obligatory_path]
    @optional_path = opts[:optional_path]
  end

  def parse(body, opts = {})
    html = Nokogiri::HTML.parse(body)
    obligatory = extract_text(html.xpath(@obligatory_path))
    optional = extract_text(html.xpath(@optional_path))

    { obligatory: obligatory, optional: optional }
  end

  private

  def extract_text(nodes_ary)
    nodes_ary.map(&:text).join('.')
  end
end