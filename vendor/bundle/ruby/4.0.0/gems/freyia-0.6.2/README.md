# Freyia

Define and execute automated tasks in Ruby like the party girl you are! Let your freak _Norse goddess_ flag fly. 🥳

> [!NOTE]
> Freyia is a hard-fork of extracted shell/actions components from the [Thor](https://github.com/rails/thor) project, now modernized and usable in any Ruby application with any command line tooling.
>
> **Historical factoid:** Much of the original work on Thor actions and its serving as the substrate for Rails generators was done by [José Valim](https://github.com/josevalim), who is now well-known as the creator of the Elixir programming language. Some of that work was in turn based on the [Templater](https://github.com/jnicklas/templater) gem.

## Installation

```bash
bundle add freyia
```

## Usage

Freyia is centered around the idea of running an "automation script". This is kicked off using a base instance, but that instance can incorporate other automation scripts using `apply` and those scripts don't need to include any of the typical Ruby class ceremony (everything in those scripts are run as if it were written to execute in the base instance via the magic of `instance_exec`).

An example using the standard Freya base:

```ruby
class TestAutomation < Freyia::Base
  def call(external_file)
    say_status :test, "This is a test!"
    run "ls"
    copy_file "data.txt"
    apply external_file
  end
end

TestAutomation.new(source: "dirs/source", dest: "dirs/dest").call("another/automation.rb")
```

You can also include a mixin into your own class, which will require you to set the source(s) and destination manually.

```ruby
class MyAutomationSuperclass
  include Freyia::Setup

  def initialize
    self.source_paths = Array("my_src/folder").map { File.expand_path(_1, Dir.pwd) }
    self.destination_root = File.expand_path("my_dest/folder", Dir.pwd)
  end
end

class MyLatestAutomation < MyAutomationSuperclass
  def call
    # ...automation script here
  end
end
```

Note that the use of `call` here is simply a convention…you can write automations in any method or architecture you prefer.

> [!NOTE]
> Freyia file automations are generally in line with prior Thor actions, but one big difference: the template extension is now `.tmpl`, not `.tt`. In addition, we are phasing out "reversable actions". Automations are generally understood to be run on Git-backed repos which offer their own form of reverting changes.

Most of the Freyia documentation as at the [API level which you can read here](https://www.rubydoc.info/gems/freyia). Most important resources:

* [Freyia::Automations](https://www.rubydoc.info/gems/freyia/Freyia/Automations)
* [Freyia::Shell::Basic](https://www.rubydoc.info/gems/freyia/Freyia/Shell/Basic)

All of the automations listed there, such as `say_status`, `inject_into_file`, `template`, etc. are available to you within automation scripts.

## Template Types

The `template` automation lets you create files based on templates you define in either ERB or [Serbea](https://www.serbea.dev) syntax. The default is ERB, but you override the default for a Freyia base using the `template_type` class method:

```ruby
class TestAutomation < Freyia::Base
  template_type :serbea
end
```

You can also override the base default on a per-call basis using the `type` keyword argument:

```ruby
template "configuration.yaml", type: :serbea
```

This would process a `configuration.yaml.tmpl` in your source folder to output a `configuration.yaml` file to the destination, like so:

```yaml
---
current_ruby_version: {{ RUBY_VERSION | to_json }}
```

> [!NOTE]
> Freyia doesn't ship with a Serbea dependency, so you will also need to `bundle add serbea` or reference it in a `.gemspec` file if you want to use Serbea-based templates.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on Codeberg at https://codeberg.org/jaredwhite/freyia. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://codeberg.org/jaredwhite/freyia/src/branch/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
