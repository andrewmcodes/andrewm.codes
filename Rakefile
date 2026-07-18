require "bridgetown"
require "json"
require "yaml"
require "date"

Bridgetown.load_tasks

task default: :deploy

desc "Build the Bridgetown site for deployment"
task deploy: [:clean, "frontend:build"] do
  Bridgetown::Commands::Build.start
end

desc "Build the site in a test environment"
task :test do
  ENV["BRIDGETOWN_ENV"] = "test"
  Bridgetown::Commands::Build.start
end

require "minitest/test_task"
Minitest::TestTask.create(:test) do |t|
  t.warning = false
end

desc "Runs the clean command"
task :clean do
  Bridgetown::Commands::Clean.start
end

namespace :frontend do
  desc "Build the frontend with esbuild for deployment"
  task :build do
    sh "npm run esbuild"
  end

  desc "Watch the frontend with esbuild during development"
  task :dev do
    sh "npm run esbuild-dev"
  rescue Interrupt
  end
end

namespace :data do
  desc "Validate required source data files and minimal schema"
  task :validate do
    data_dir = File.join(__dir__, "src", "_data")

    json_files = %w[accounts.json appearances.json remote_ruby.json webmentions.json]
    json_files.each do |file|
      path = File.join(data_dir, file)
      raise "Missing required data file: #{path}" unless File.exist?(path)
      JSON.parse(File.read(path))
    end

    podcasts = YAML.safe_load_file(File.join(data_dir, "podcasts.yml"), permitted_classes: [Date, Time]) || []
    raise "podcasts.yml must contain an array" unless podcasts.is_a?(Array)

    talks = YAML.safe_load_file(File.join(data_dir, "talks.yml"), permitted_classes: [Date, Time]) || []
    raise "talks.yml must contain an array" unless talks.is_a?(Array)

    remote_ruby = JSON.parse(File.read(File.join(data_dir, "remote_ruby.json")))
    %w[id title url published_at].each do |key|
      raise "remote_ruby.json missing required key: #{key}" if remote_ruby[key].to_s.strip.empty?
    end

    oss_path = File.join(data_dir, "oss.json")
    next unless File.exist?(oss_path)

    oss = JSON.parse(File.read(oss_path))
    raise "oss.json must contain at least one project" unless oss.is_a?(Array) && oss.any?
    unless oss.all? { |item| item.is_a?(Hash) && item["name"].to_s != "" && item["url"].to_s != "" }
      raise "oss.json entries must include non-empty name and url"
    end
  end
end
