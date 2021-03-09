#!/usr/bin/env ruby
# frozen_string_literal: true
require "pathname"
require "bridgetown"
require "dotenv/load"
require "pry"
require "dry-struct"
require "contentful/management"

SPACE_ID = ENV["CONTENTFUL_SPACE_ID"]
CF_ACCESS_TOKEN = ENV["CONTENTFUL_ACCESS_TOKEN"]
CF_ENVIRONMENT = "main"

client = Contentful::Management::Client.new(CF_ACCESS_TOKEN)
space = client.spaces.find(SPACE_ID)
environment = client.environments(SPACE_ID).find(CF_ENVIRONMENT)
entries = environment.entries.all
books = entries.find "book"

# books = []
# book = environment.content_types.find 'book'
# data_file_path = File.expand_path("../../../src/_data/books.json", Pathname.new(__FILE__).realpath)
# json = JSON.parse(File.read(data_file_path))

# json.each do |j|
#   books << book.entries.create(
#     title: j["name"],
#     url: j["url"],
#     authors: j["authors"],
#     audiobook: j["audio"],
#     complete: j["complete"],
#     rating: j["stars"]
#   )
# end

# books.map(&:publish)

pages = []
page = environment.content_types.find "page"
data_file_path = File.expand_path("../../../src/_data/pages.json", Pathname.new(__FILE__).realpath)
json = JSON.parse(File.read(data_file_path))

json.each { |j| pages << page.entries.create(title: j["title"], description: j["description"], content: j["content"]) }

pages.map(&:publish)
