# -*- encoding: utf-8 -*-
# stub: signalize 1.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "signalize".freeze
  s.version = "1.3.1".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "homepage_uri" => "https://codeberg.org/jaredwhite/signalize", "source_code_uri" => "https://codeberg.org/jaredwhite/signalize" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jared White".freeze, "Preact Team".freeze]
  s.date = "2025-08-16"
  s.description = "A Ruby port of Signals, providing reactive variables, derived computed state, side effect callbacks, and batched updates.".freeze
  s.email = ["jared@whitefusion.studio".freeze]
  s.homepage = "https://codeberg.org/jaredwhite/signalize".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0.0".freeze)
  s.rubygems_version = "3.5.16".freeze
  s.summary = "A Ruby port of Signals, providing reactive variables, derived computed state, side effect callbacks, and batched updates.".freeze

  s.installed_by_version = "4.0.6".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<concurrent-ruby>.freeze, ["~> 1.2".freeze])
end
