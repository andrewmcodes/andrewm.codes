#!/usr/bin/env ruby
# frozen_string_literal: true
require "pathname"
require "bridgetown"
require "dotenv/load"
require "pry"
require "dry-struct"
require "gqli"

SPACE_ID = ENV["CONTENTFUL_SPACE_ID"]
CF_ACCESS_TOKEN = ENV["CONTENTFUL_CONTENT_DELIVERY_API_TOKEN"]
CONTENTFUL_GQL = GQLi::Contentful.create(SPACE_ID, CF_ACCESS_TOKEN)

SysBase =
  GQLi::DSL.fragment("SysBase", "Sys") do
    sys do
      id
      publishedAt
      firstPublishedAt
      publishedVersion
    end
  end

BookFragment =
  GQLi::DSL.fragment("BookFragment", "BookCollection") do
    items do
      ___ SysBase
      title
      url
      authors
      audiobook
      complete
      rating
      cloudinaryImage
    end
  end

Query = GQLi::DSL.query { bookCollection { ___ BookFragment } }

response = CONTENTFUL_GQL.execute(Query)
# response.data.each do |data|
#   puts data.key
# end
