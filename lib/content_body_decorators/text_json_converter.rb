class TextJsonConverter
  def initialize(converter = nil)
    @converter = converter
  end

  def convert(content) # content { body: , url: }
    converted = JSON(url: content[:url], body: content[:body])
    @converter ? @converter.convert(converted) : converted
  end
end
