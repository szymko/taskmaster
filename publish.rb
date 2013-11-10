#!/usr/bin/env ruby
require_relative './app/app'

client = Neo4rubyClient.new
client.open("neo4ruby")
converter = HtmlTextConverter.new(TextJsonConverter.new(), xpath: "//body",
                                  strategy: BareTextStrategy.new)

commands = [ FetchPageContents.new(limit: TaskmasterConfig[:queue][:limit]),
             CallClient.new(converter: converter, client: client),
             UpdatePageContents.new ]

worker = GenericWorker.new("PublishWorker", commands)
worker.perform()
