class GetPages
  def initialize(crawler: Crawler.new(agent: "Pszemek"))
    @crawler = crawler
  end

  def perform(**opts)
    @crawler.get(opts[:pages].map(&:url))
    { crawler: @crawler }
  end
end
