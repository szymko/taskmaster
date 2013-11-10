class HtmlTextConverter
  def initialize(converter, opts) # opts #=> { xpath:, strategy:, converter: }
    @converter = converter
    @strategy = opts[:strategy]
    @opts = opts
  end

  def convert(content) # content { body: , url: }
    body = @strategy.parse(content[:body], @opts)
    converted = { url: content[:url], body: body }
    @converter.convert(converted)
  end
end
