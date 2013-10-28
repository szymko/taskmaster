require_relative './app/app.rb'
require 'pry'

unless Page.find_by(url: "http://en.wikipedia.org/wiki/Main_Page")
  Page.create(url: "http://en.wikipedia.org/wiki/Main_Page", status: "waiting")
end

@worker = ScrapperWorker.new

2.times do
  @worker.perform
end

p "The end"

sleep
