# -*- encoding: utf-8 -*-
# stub: syntax_tree 6.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "syntax_tree".freeze
  s.version = "6.3.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "rubygems_mfa_required" => "true" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Kevin Newton".freeze]
  s.bindir = "exe".freeze
  s.date = "2025-07-17"
  s.email = ["kddnewton@gmail.com".freeze]
  s.executables = ["stree".freeze, "yarv".freeze]
  s.files = ["exe/stree".freeze, "exe/yarv".freeze]
  s.homepage = "https://github.com/kddnewton/syntax_tree".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0".freeze)
  s.rubygems_version = "3.6.2".freeze
  s.summary = "A parser based on ripper".freeze

  s.installed_by_version = "4.0.6".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<prettier_print>.freeze, [">= 1.2.0".freeze])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<minitest>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rake>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<rubocop>.freeze, [">= 0".freeze])
  s.add_development_dependency(%q<simplecov>.freeze, [">= 0".freeze])
end
