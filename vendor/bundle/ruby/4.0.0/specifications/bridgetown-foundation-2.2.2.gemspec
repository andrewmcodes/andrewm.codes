# -*- encoding: utf-8 -*-
# stub: bridgetown-foundation 2.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "bridgetown-foundation".freeze
  s.version = "2.2.2".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/bridgetownrb/bridgetown/issues", "changelog_uri" => "https://github.com/bridgetownrb/bridgetown/releases", "homepage_uri" => "https://github.com/bridgetownrb/bridgetown/tree/main/bridgetown-foundation", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/bridgetownrb/bridgetown" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Bridgetown Team".freeze]
  s.date = "2026-07-06"
  s.email = "maintainers@bridgetownrb.com".freeze
  s.homepage = "https://github.com/bridgetownrb/bridgetown/tree/main/bridgetown-foundation".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.3".freeze)
  s.rubygems_version = "3.5.22".freeze
  s.summary = "Ruby language extensions and other utilities useful for the Bridgetown ecosystem".freeze

  s.installed_by_version = "4.0.6".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<dry-inflector>.freeze, [">= 1.0".freeze])
  s.add_runtime_dependency(%q<hash_with_dot_access>.freeze, ["~> 2.0".freeze])
  s.add_runtime_dependency(%q<inclusive>.freeze, ["~> 1.0".freeze])
  s.add_runtime_dependency(%q<zeitwerk>.freeze, ["~> 2.5".freeze])
end
