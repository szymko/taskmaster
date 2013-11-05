require_relative './app/app.rb'
require 'pry'

unless Page.find_by(url: "http://en.wikipedia.org/wiki/Main_Page")
  Page.create(url: "http://en.wikipedia.org/wiki/Main_Page", status: "waiting")
end

crawler = Crawler.new(agent: "Pszemek")
page_update = PageUpdate.new

@worker = DownloadWorker.new(page_update: page_update, crawler: crawler)

3.times do
  @worker.perform(subset: Page.wiki, pattern: /\/\/en\.wikipedia\.org(?!\/wiki\/User)/)
end

p "The end"
