require 'forwardable'
require 'scrapper'

class Crawler
  class AgentNullError < StandardError; end

  extend Forwardable

  ASYNC = 10

  def initialize(opts) #opts = { agent: "Required", engine: ..., robots: ...}

    @engine, @robots = build(opts)
    @agent = opts[:agent] || raise(AgentNullError)
  end

  def get(*urls)
    selected = urls.flatten.select do |u|
      @robots.allowed?(url: u, agent: @agent, download: true)
    end

    @engine.get(selected)
  end

  def scrap(pattern)
    @engine.scrap do |u|
      (u =~ pattern) && @robots.allowed?(url: u, agent: @agent, download: true)
    end
  end

  private

  def build(opts)
    engine = opts[:engine] ||
              Scrapper::Crawler.new(async: ASYNC, user_agent: opts[:agent])
    robots = opts[:robots] || Robots::Index.new()

    [engine, robots]
  end

  def_delegators :@engine, :responses, :errors, :urls
end
