#!/usr/bin/env ruby
# frozen_string_literal: true

# Fetches webmentions for the site from webmention.io and writes them to
# src/_data/webmentions.json (a JF2 feed). Bridgetown exposes the result as
# `site.data.webmentions`; the Webmentions component filters it per post.
#
# Auth: webmention.io's per-domain feed requires the account API token. Set
# WEBMENTION_IO_TOKEN (Keychain via fnox locally; repo secret in CI). When the
# token is absent the script logs and exits 0 WITHOUT touching the committed
# file, so builds never break on a missing secret.
#
# Run: `mise run webmentions` (fnox-wrapped) or `ruby scripts/fetch-webmentions.rb`.

require "json"
require "net/http"
require "uri"

DOMAIN = "andrewm.codes"
PER_PAGE = 200
OUT = File.expand_path("../src/_data/webmentions.json", __dir__)

token = ENV["WEBMENTION_IO_TOKEN"]
if token.nil? || token.empty?
  warn "WEBMENTION_IO_TOKEN not set; skipping fetch, leaving src/_data/webmentions.json unchanged."
  exit 0
end

# Page through the JF2 feed until a short page signals the end.
def fetch_all(token)
  children = []
  page = 0

  loop do
    uri = URI("https://webmention.io/api/mentions.jf2")
    uri.query = URI.encode_www_form(
      "domain" => DOMAIN,
      "token" => token,
      "per-page" => PER_PAGE,
      "page" => page
    )

    response = Net::HTTP.get_response(uri)
    unless response.is_a?(Net::HTTPSuccess)
      raise "webmention.io responded #{response.code} #{response.message}"
    end

    batch = JSON.parse(response.body)["children"] || []
    children.concat(batch)
    break if batch.length < PER_PAGE

    page += 1
  end

  children
end

children = fetch_all(token)
# Newest first so the component can take the most recent without re-sorting.
children.sort_by! { |wm| wm["wm-received"].to_s }
children.reverse!

feed = {"type" => "feed", "name" => "Webmentions", "children" => children}
File.write(OUT, JSON.pretty_generate(feed) + "\n")
puts "Wrote #{children.length} webmentions to #{OUT}"
