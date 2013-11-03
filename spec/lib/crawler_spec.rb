require_relative '../spec_helper'

describe Crawler do

  context "when initializing" do
    describe ".new" do
      it { expect{Crawler.new({})}.to raise_error(Crawler::AgentNullError) }
    end
  end

  context "when calling the network" do
    describe "#get" do
      it "checks robots for url" do
        r = robots()
        crawler = build(robots: r, engine: engine())

        crawler.get(urls().first)
        expect(r).to have_received(:allowed?).with(url: urls().first,
                                                   agent: agent(), download: true)
      end

      it "performs a request" do
        e = engine()

        crawler = build(robots: robots(), engine: e)
        crawler.get(urls())
        expect(e).to have_received(:get).with(urls())
      end
    end
  end

  context "when processing response" do

    describe "#scrap" do
      it "uses engine" do
        e = engine(to_yield: urls().first)
        crawler = build(robots: robots(), engine: e)
        crawler.scrap(/.*/)

        expect(e).to have_received(:scrap).once
      end

      it "checks the robots" do
        r = robots()
        crawler = build(robots: r, engine: engine())
        crawler.scrap(/.*/)

        expect(r).to have_received(:allowed?).with(url: urls().first,
                                                   agent: agent(), download: true)
      end

      it "checks the pattern" do
        url = double("url", :=~ => true)
        e = engine(to_yield: url)
        crawler = build(robots: robots(), engine: e)

        crawler.scrap(/.*/)
        expect(url).to have_received(:=~).with(/.*/).once
      end

      it "does not change engine response" do
        e = double("engine", scrap: 7)
        crawler = build(robots: robots(), engine: e)

        expect(crawler.scrap(/.*/)).to eq(7)
      end
    end
  end

  def build(opts)
    opts = { agent: "Agent" }.merge(opts)
    Crawler.new(opts)
  end

  def urls
    ["http://www.example.com/", "https://wwww.google.com"]
  end

  def engine(response: nil, to_yield: "http://www.example.com/")
    e = double("engine", get: response)
    allow(e).to receive(:scrap).and_yield(to_yield)
    e
  end

  def robots(allowance: true)
    double("robots", allowed?: allowance)
  end

  def agent(name = "Agent")
    name
  end
end
