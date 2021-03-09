#!/usr/bin/env ruby
# frozen_string_literal: true
require "pathname"
require "bridgetown"
require "dotenv/load"
require "pry"
require "graphlient"
require "dry-struct"

class Strapi
  def client
    @client ||= Graphlient::Client.new(api_url, headers: headers)
  end

  private

  def get_data_file_path(resource)
    File.expand_path("../../../src/_data/#{resource}.json", Pathname.new(__FILE__).realpath)
  end

  def headers
    { "Authorization" => "Bearer #{api_token}" }
  end

  def api_url
    @api_url ||=
      Bridgetown.env.development? ? "http://localhost:1337/graphql" : "https://andrewmcodes.herokuapp.com/graphql"
  end

  def api_token
    token = ENV["STRAPI_API_TOKEN"]
    raise StandardError.new "STRAPI_API_TOKEN is nil" unless token
    token
  end
end

client = Strapi.new.client

SHARED = "id created_at updated_at"
ICON = "icon { url }"

accounts_query = <<~QUERY
  accounts {
    #{SHARED}
    title
    url
    username
    #{ICON}
  }
QUERY

amas_query = <<~QUERY
  amas {
    #{SHARED}
    question
    answer
    published_at
  }
QUERY

articles_query = <<~QUERY
  articles {
    #{SHARED}
    title
    description
    dev_to_url
    cover_image
    canonical_url
    content
    published_at
  }
QUERY

books_query = <<~QUERY
  books {
    #{SHARED}
    name
    url
    audio
    image { url }
    stars
    authors
    complete
  }
QUERY

links_query = <<~QUERY
  links {
    #{SHARED}
    name
    url
    footer
    nav
    published_at
  }
QUERY

pages_query = <<~QUERY
  pages {
    #{SHARED}
    content
    title
    description
    published_at
  }
QUERY

podcast_episodes_query = <<~QUERY
  podcastEpisodes {
    #{SHARED}
    name
    url
    interview
    published_at
  }
QUERY

podcasts_query = <<~QUERY
  podcasts {
    #{SHARED}
    name
    description
    image { url }
    url
    active
    podcast_episodes {
      #{SHARED}
      name
      url
      interview
      published_at
     }
  }
QUERY

projects_query = <<~QUERY
  projects {
    #{SHARED}
    name
    description
    image { url }
    content
    favorite
    url
    type
    published_at
  }
QUERY

resources_query = <<~QUERY
  resources {
    #{SHARED}
    name
    description
    url
    image { url }
    type
    published_at
  }
QUERY

response = client.query <<~GRAPHQL
  query {
    #{accounts_query}
    #{amas_query}
    #{articles_query}
    #{books_query}
    #{links_query}
    #{pages_query}
    #{podcast_episodes_query}
    #{podcasts_query}
    #{projects_query}
    #{resources_query}
  }
GRAPHQL

response.data.each { |data| data.map(&:to_h).to_json }
