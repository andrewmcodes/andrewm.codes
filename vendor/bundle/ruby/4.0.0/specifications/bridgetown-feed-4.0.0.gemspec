# -*- encoding: utf-8 -*-
# stub: bridgetown-feed 4.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "bridgetown-feed".freeze
  s.version = "4.0.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Bridgetown Team".freeze]
  s.date = "2025-09-16"
  s.email = "maintainers@bridgetownrb.com".freeze
  s.homepage = "https://github.com/bridgetownrb/bridgetown-feed".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1.0".freeze)
  s.rubygems_version = "3.5.16".freeze
  s.summary = "A Bridgetown plugin to generate an Atom feed of your Bridgetown posts".freeze

  s.installed_by_version = "4.0.6".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<bridgetown>.freeze, [">= 1.2.0".freeze])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rss>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<nokogiri>.freeze, ["~> 1.6".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0".freeze])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0".freeze])
  s.add_development_dependency(%q<rubocop-bridgetown>.freeze, ["~> 0.2".freeze])
  s.add_development_dependency(%q<typhoeus>.freeze, [">= 0.7".freeze, "< 2.0".freeze])
end
