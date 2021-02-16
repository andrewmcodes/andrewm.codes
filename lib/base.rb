#!/usr/bin/env ruby
# frozen_string_literal: true
require "httparty"
require "pathname"
require "bridgetown"

class Base
  include HTTParty

  def initialize(resource)
    @api_url = Bridgetown.env.development? ? "http://localhost:1337" : "https://andrewmcodes.herokuapp.com"
    @resource = resource
  end

  def all
    self.class.get("#{@api_url}/#{@resource}?_sort=updated_at", header: header)
  end

  def dump(resource)
    File.write(data_file_path, JSON.dump(JSON.parse(resource)))
  end

  private

  def data_file_path
    File.expand_path("../../src/_data/#{@resource}.json", Pathname.new(__FILE__).realpath)
  end

  def header
    { "Content-Type" => "application/json" }
  end
end
