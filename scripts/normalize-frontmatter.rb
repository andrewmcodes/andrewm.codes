#!/usr/bin/env ruby
require "yaml"

Dir.glob("src/{_posts,_projects,_pages}/**/*.{md,erb}").each do |file|
  content = File.read(file)
  next unless content.start_with?("---\n")

  parts = content.split(/^---$/, 3)
  next unless parts.size == 3

  front_matter = YAML.safe_load(parts[1], permitted_classes: [Time, Date])
  next unless front_matter.is_a?(Hash)

  if front_matter["category"]
    front_matter["categories"] ||= Array(front_matter.delete("category"))
  end

  if front_matter["status"] == "featured"
    front_matter["featured"] = true
    front_matter.delete("status")
  end

  %w[date last_modified_at].each do |key|
    value = front_matter[key]
    next unless value.is_a?(String)
    front_matter[key] = Time.parse(value)
  rescue ArgumentError
    next
  end

  File.write(file, "---\n#{front_matter.to_yaml.sub(/^---\n/, "")}---\n#{parts[2]}")
  puts "✓ #{file}"
end
