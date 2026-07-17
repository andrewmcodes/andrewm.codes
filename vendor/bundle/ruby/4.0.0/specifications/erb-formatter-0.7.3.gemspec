# -*- encoding: utf-8 -*-
# stub: erb-formatter 0.7.3 ruby lib

Gem::Specification.new do |s|
  s.name = "erb-formatter".freeze
  s.version = "0.7.3".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/nebulab/erb-formatter/releases", "homepage_uri" => "https://github.com/nebulab/erb-formatter#readme", "source_code_uri" => "https://github.com/nebulab/erb-formatter" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Elia Schito".freeze]
  s.bindir = "exe".freeze
  s.date = "2024-06-24"
  s.email = ["elia@schito.me".freeze]
  s.executables = ["erb-format".freeze, "erb-formatter".freeze]
  s.files = ["exe/erb-format".freeze, "exe/erb-formatter".freeze]
  s.homepage = "https://github.com/nebulab/erb-formatter#readme".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.5.4".freeze
  s.summary = "Format ERB files with speed and precision.".freeze

  s.installed_by_version = "4.0.6".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<syntax_tree>.freeze, ["~> 6.0".freeze])
  s.add_development_dependency(%q<tailwindcss-rails>.freeze, ["~> 2.0".freeze])
  s.add_development_dependency(%q<m>.freeze, ["~> 1.0".freeze])
end
