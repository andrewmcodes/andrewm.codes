# -*- encoding: utf-8 -*-
# stub: bridgetown-svg-inliner 3.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "bridgetown-svg-inliner".freeze
  s.version = "3.0.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ayush Newatia".freeze]
  s.date = "2026-01-29"
  s.email = "ayush@hey.com".freeze
  s.homepage = "https://github.com/ayushn21/bridgetown-svg-inliner".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0.0".freeze)
  s.rubygems_version = "3.6.2".freeze
  s.summary = "Liquid and ERB helper for Bridgetown to inline SVG files within HTML".freeze

  s.installed_by_version = "4.0.6".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<bridgetown>.freeze, [">= 2.0".freeze, "< 4.0".freeze])
  s.add_runtime_dependency(%q<nokogiri>.freeze, [">= 0".freeze])
  s.add_runtime_dependency(%q<csv>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rubocop-bridgetown>.freeze, [">= 0".freeze])
end
