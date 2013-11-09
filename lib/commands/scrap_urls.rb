class ScrapUrls
  def initialize(pattern: /.*/)
    @pattern = pattern
  end

  def perform(**opts)
    { urls: opts[:crawler].scrap(@pattern) }
  end
end
