require_relative '../test_helper'

class CrawlerTest < MiniTest::Unit::TestCase
  def setup
    @crawler = Crawler.new(agent: "SomeAgent")
    @pattern = /.*/
    @urls = ["http://www.example.com/", "https://wwww.google.com"]
  end

  def test_it_tries_to_get_page
    Scrapper::Crawler.any_instance.expects(:get).with(@urls)
    Robots::Index.any_instance.expects(:allowed?).twice.returns(true)
    @crawler.get(@urls)
  end

  def test_it_scraps_urls
    Scrapper::Crawler.any_instance.expects(:scrap)
    @crawler.scrap(@pattern)
  end

  def test_it_uses_robots_rules
    Scrapper::Crawler.any_instance.expects(:scrap).yields(@urls.first).returns([])
    Robots::Index.any_instance.expects(:allowed?).with(url: @urls.first,
                                                       agent: "SomeAgent",
                                                       download: true)
    assert_equal [], @crawler.scrap(@pattern)
  end

end
