require 'forwardable'
require 'scrapper'

class Crawler
  class AgentNullError < StandardError; end

  extend Forwardable

  def initialize(opts) #opts = { agent: "Required", engine: ..., robots: ...}

    @engine, @robots = build(opts)
    @agent = opts[:agent] || raise(AgentNullError)
  end

  def get(*urls)
    selected = urls.flatten.select do |u|
      begin
        @robots.allowed?(url: u, agent: @agent, download: true)
      rescue Exception => e
        TaskLogger.log_exception(exception: e, url: u)
        raise e
      end
    end

    @engine.get(selected)
  end

  def scrap(pattern)
    @engine.scrap do |u|
      begin
        (u =~ pattern) && @robots.allowed?(url: u, agent: @agent, download: true)
      rescue Exception => e
        TaskLogger.log_exception(exception: e, url: u)
        raise e
      end
    end
  end

  private

  def build(opts)
    engine = opts[:engine] ||
              Scrapper::Crawler.new(async: TaskmasterConfig[:crawler][:connections], user_agent: opts[:agent])
    robots = opts[:robots] || Robots::Index.new()

    [engine, robots]
  end

  def_delegators :@engine, :responses, :errors, :urls
end
