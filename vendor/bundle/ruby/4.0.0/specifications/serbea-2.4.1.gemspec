# -*- encoding: utf-8 -*-
# stub: serbea 2.4.1 ruby lib

Gem::Specification.new do |s|
  s.name = "serbea".freeze
  s.version = "2.4.1".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Bridgetown Team".freeze]
  s.date = "2025-11-26"
  s.email = "maintainers@bridgetownrb.com".freeze
  s.homepage = "https://codeberg.org/jaredwhite/serbea".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.1".freeze)
  s.rubygems_version = "3.3.26".freeze
  s.summary = "Similar to ERB, Except Awesomer".freeze

  s.installed_by_version = "4.0.6".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<erubi>.freeze, [">= 1.13".freeze])
  s.add_runtime_dependency(%q<tilt>.freeze, [">= 2.6".freeze])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0".freeze])
  s.add_development_dependency(%q<rubocop-bridgetown>.freeze, ["~> 0.7".freeze])
end
