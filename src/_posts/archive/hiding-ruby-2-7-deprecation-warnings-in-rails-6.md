---
series: null
featured: false
title: Hiding Ruby 2.7 Deprecation Warnings in Rails 6
description: Hiding Ruby 2.7 Deprecation Warnings in Rails 6   If you have upgraded your Rails app to Rub...
urls:
  dev_to: 'https://dev.to/andrewmcodes/hiding-ruby-2-7-deprecation-warnings-in-rails-6-2mil'
tags:
  - ruby
  - rails
  - beginners
  - tutorial
categories: tutorial
date: '2020-02-06T05:47:17Z'
last_modified_at: '2022-01-29T17:01:41.595Z'
---

If you have upgraded your Rails app to Ruby 2.7, you are probably seeing a lot of deprecation messages in your console. You should first make sure that none of these messages are coming from your code, and address them if they are! If the deprecations are coming mostly from Rails, it may be time to disable the messages and save yourself from messy terminal output.

The TL;DR is that you need to use `RUBYOPT='-W:no-deprecated -W:no-experimental'` to disable the deprecations. This will also disable experimental feature warnings as well.

Here are some options you have to make that happen. But first, lets create a new Rails app to experiment with!

## Generate a new Rails app with Ruby 2.7

You can either use the CLI or [this template](https://github.com/andrewmcodes/rails_template/generate).

If you use the CLI, I recommend something like:

```sh
rails new silence_ruby_2_7_deprecations -d postgresql --webpack=stimulus
```

## Method #1: Using `dotenv-rails`

If you are using the [dotenv-rails](https://github.com/bkeepers/dotenv/) gem, or another method of using `.env` files, simply add the following to your `.env` file:

```sh
export RUBYOPT='-W:no-deprecated -W:no-experimental'
```

Then run the following in the root of the project:

```sh
source .env
```

You should no longer be seeing the Ruby 2.7 deprecation warnings coming out of Rails! 🎉

## Method #2: Prefixing commands

Another option you have for ignoring the Ruby 2.7 deprecation warnings is to prefix all of your Rails commands with `RUBYOPT='-W:no-deprecated -W:no-experimental'`.

Example:

- `rails server` would become `RUBYOPT='-W:no-deprecated -W:no-experimental' rails server`
- `rails console` would become `RUBYOPT='-W:no-deprecated -W:no-experimental' rails console`
- etc.

This is obviously not ideal but it will work!

## Method #3: Updating your environment

If you want to disable these deprecation messages everywhere, you can add the following to your `~/.zshrc` or `~/.bashrc`:

`export RUBYOPT='-W:no-deprecated -W:no-experimental'`

This will disable deprecation and experimental feature warnings for all versions of Ruby, for all projects. I have heard of this creating issues for some so you may want to be careful using this method if you work on multiple apps that aren't on Ruby 2.7.

[View repo for this post](https://github.com/andrewmcodes/silence-ruby-2-7-deprecations)

Hopefully this helps! Happy coding!
