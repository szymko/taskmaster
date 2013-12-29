#!/usr/bin/env ruby
require_relative './app/app.rb'

interrupt = false
interrupt_co = 0
trap("SIGINT") do
  interrupt_co += 1
  if interrupt_co == 1
    puts "\nPlease wait for graceful exit, or press CTRL+C to leave now."
    interrupt = true
  elsif interrupt_co > 1
    exit!
  end
end


unless Page.find_by(url: "http://en.wikipedia.org/wiki/Main_Page")
  Page.create(url: "http://en.wikipedia.org/wiki/Main_Page", status: "waiting")
end

commands = [FetchPages.new(subset: Page.wiki),
            GetPages.new(),
            ScrapUrls.new(pattern: Regexp.compile(TaskmasterConfig[:crawler][:url_pattern])),
            InsertPages.new(),
            UpdatePages.new()]

scrapping_worker = GenericWorker.new("DownloadAndScrappingWorker", commands)
non_scrapping_worker = GenericWorker.new("DownloadWorker", commands.values_at(0,1,4))

loop do
  unless interrupt
    if Page.success.count > (0.4 * Page.waiting.count)
      scrapping_worker.perform()
    else
      non_scrapping_worker.perform()
    end
  else
    p "Exiting Download..."
    break
  end
end
