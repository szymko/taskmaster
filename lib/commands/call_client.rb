class CallClient
  def initialize(opts)
    @converter, @client = opts[:converter], opts[:client]
  end

  def perform(**opts)
    published = opts[:page_contents].reduce([]) do |p, pc|
      p << pc if publish(pc)
    end

    { published: published }
  end

  private

  def publish(page_content)
    content = { url: page_content.page.url, body: page_content.body }
    TaskLogger.log(level: :debug, msg: "Publishing page url: #{content[:url]}...")
    @client.call(@converter.convert(content))
  end
end
