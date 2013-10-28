require 'forwardable'
require 'scrapper'

class Crawler

  extend Forwardable

  ASYNC = 10

  def initialize(opts) #opts = { agent: "Required", robots: ... }
    @agent = opts[:agent]

    @robots = Robots::Index.new()
    @robots.add(opts[:robots]) if opts[:robots]

    @crawler = Scrapper::Crawler.new(async: ASYNC, user_agent: @agent)
  end

  def get(*urls)
    selected = urls.flatten.select do |u|
      @robots.allowed?(url: u, agent: @agent, download: true)
    end

    @crawler.get(selected)
  end

  def scrap(pattern)
    @crawler.scrap do |u|
      (u =~ pattern) && @robots.allowed?(url: u, agent: @agent, download: true)
    end
  end

  def_delegators :@crawler, :responses, :errors, :urls
end
