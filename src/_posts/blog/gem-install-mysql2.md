---
title: gem install mysql2
description: I've come across this error several times throughout my development career so
  I figured it was finall...
urls:
  dev_to: https://dev.to/andrewmcodes/gem-install-mysql2-6o1
tags:
  - ruby
  - rails
  - mysql
  - gem
category: tutorial
date: 2020-12-11T12:20:02Z
last_modified_at: 2022-01-29T17:01:41.577Z
---

I've come across this error several times throughout my development career so I figured it was finally time to write it down.

## Scenario

Whenever I try to install certain versions of the `mysql2` gem in a Ruby on Rails application, I get the following error:

```
Gem::Ext::BuildError: ERROR: Failed to build gem native extension
...
make "DESTDIR="
compiling client.c
compiling infile.c
compiling mysql2_ext.c
compiling result.c
compiling statement.c
linking shared-object mysql2/mysql2.bundle
ld: library not found for -lssl
clang: error: linker command failed with exit code 1 (use -v to see invocation)
make: *** [mysql2.bundle] Error 1

make failed, exit code 2

An error occurred while installing mysql2 (0.5.2), and Bundler cannot continue.
Make sure that `gem install mysql2 -v '0.5.2'` succeeds before bundling.
```

## Solution

In order to fix this issue on macOS, first make sure that you have `cmake` installed.

```sh
brew install cmake
```

Then you can install the gem via the following command:

```sh
gem install mysql2 -v '0.5.2' -- --with-ldflags=-L/usr/local/opt/openssl/lib --with-cppflags=-I/usr/local/opt/openssl/include
```

Hope this helps save someone some time!
