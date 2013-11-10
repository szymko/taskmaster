class CallClient
  def initialize(opts)
    @converter, @client = opts[:converter], opts[:client]
  end

  def perform(**opts)
    published = opts[:page_contents].inject([]) do |p, pc|
      p << pc if publish(pc)
    end

    { published: published }
  end

  private

  def publish(page_content)
    content = { url: page_content.page.url, body: page_content.body }
    @client.call(@converter.convert(content))
  end
end
