#!/usr/bin/env ruby
require_relative './lib/neo4ruby_client'

client = Neo4rubyClient.new
client.open("neo4ruby")

fetched = PageContent.not_published.limit(50)
not_published = []
published = []

fetched.each do |p|
  (client.call(Parser.parse(p.body), p.id) == true ? published : not_published) << p
end

ensure
  PageContent.where(id: published.map(&:id)).update_all({ published: true })
  client.close
end