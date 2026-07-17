# Inclusive

Compose globally-scoped Ruby modules into local packages. This makes it easy to access utility methods (aka functions) without having to type lengthy namespaces or remember which modules provide with functions at each call site (or alternatively include modules in your classes which pollute the method space).

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add inclusive

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install inclusive

## Usage

To start with, you can write your "package" (aka a standard Ruby module) containing a set of discrete functions. It's recommended you namespace your packages within higher-level modules.

```ruby
module MyOrg
  module MyPackages
    module WorkHardAtIt
      def just_do_it = puts "Don't let your dreams be dreams"
    end
  end
end
```

Then in any standard Ruby class, you can include the `Inclusive` module and use the `packages` class helper to "import" the package:

```ruby
require "inclusive"
# require the file(s) containing your package(s)

class GetToThePoint
  include Inclusive

  packages def work_hard = [MyOrg::MyPackages::WorkHardAtIt]

  def nothing_is_impossible
    work_hard.just_do_it # this will print out the motivational speech
  end
end
```

The import syntax is an array because you can import multiple packages. The imported packages will "compose" together, meaning the methods from the various package modules will all be available simultaneously. (Under the hood, a new anonymous module is created with mixins of the modules you are importing as the packages.)

In addition to creating instance methods using the `packages` class helper, you can use the `packages` method inline:

```ruby
def some_method
  my_math = packages[MyOrg::Math]

  my_math.multiply_by_100(5)
end
```

This approach isn't recommended unless you're in a context where using the class helper is impossible, such as a template (ERB, etc.) or a block which is executed by a framework. You can also call the `packages` method directly on the `Inclusive` module:

```ruby
my_math = Inclusive.packages[MyOrg::Math]
```

Class-level methods can also be created using `packages` on the "class instance" (aka singleton class) which is also helpful for other modules:

```ruby
module MyModule
  class << self
    extend Inclusive::Class

    packages def utils = [
      Packages::ThingOne,
      Packages::ThingTwo,
    ]
  end
end

MyModule.utils.run # a method from one of the imported packages
```

### Public Package Methods

If you want to be able to call a package method directly on its own module, you can extend your module and use the `public_function` helper:

```ruby
module Packages
  module MyPackage
    extend Inclusive::Public

    def some_method
      # code
    end

    public_function :some_method
  end
end
```

Now in addition to using package imports via Inclusive, you can call the module method directly:

```ruby
Packages::MyPackage.some_method
```

This is only recommended if you need to mantain an existing module's legacy behavior in a codebase while incrementally adopting Inclusive.

## but y tho 🤔

Why is this gem even needed? Well, any significantly-large project (and certainly the [Bridgetown framework](https://www.bridgetownrb.com) which gave rise to this effort) will have a "pile o' functions" which are loosely-related at best. Sometimes they're all crammed into a giant utility module or two, other times they're broken out into a handful of classes or whatever…even if they don't really need to be classes in the traditional object-oriented sense. Many other languages don't seem to have an issue with just writing utility functions and explicitly importing them in places where they're needed, but that hasn't been The Ruby Way. 

Until now. 😄

Maybe Inclusive isn't for you, but for what we need, it gets the job done. Give it a try!

----

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bin/rake install`. To release a new version, update the version number in `version.rb`, and then run `bin/rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://codeberg.org/jaredwhite/inclusive. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://codeberg.org/jaredwhite/inclusive/src/branch/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
