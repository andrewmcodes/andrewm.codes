---
categories:
  - post
title: Hiding Ruby 2.7 Deprecation Warnings in Rails 6
date: '2020-02-06T05:50:58.004Z'
excerpt: >-
  Hiding Ruby 2.7 Deprecation Warnings in Rails 6   If you have upgraded your
  Rails app to Rub...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--D535Ke7d--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/mpx3qxiyimpvz7bti141.png
comments_count: 6
positive_reactions_count: 20
tags:
  - ruby
  - rails
  - beginners
  - tutorial
dev_to_url: >-
  https://dev.to/andrewmcodes/hiding-ruby-2-7-deprecation-warnings-in-rails-6-2mil
layout: post
---

# Hiding Ruby 2.7 Deprecation Warnings in Rails 6

If you have upgraded your Rails app to Ruby 2.7, you are probably seeing a lot of deprecation messages in your console. You should first make sure that none of these messages are coming from your code, and address them if they are! If the deprecations are coming mostly from Rails, it may be time to disable the messages and save yourself from messy terminal output.

The TL;DR is that you need to use {% raw %}`RUBYOPT='-W:no-deprecated -W:no-experimental'`{% endraw %} to disable the deprecations. This will also disable experimental feature warnings as well.

Here are some options you have to make that happen. But first, lets create a new Rails app to experiment with!

## Generate a new Rails app with Ruby 2.7

You can either use the CLI or [this template](https://github.com/andrewmcodes/rails_template/generate).

If you use the CLI, I recommend something like:

{% raw %}```sh
rails new silence_ruby_2_7_deprecations -d postgresql --webpack=stimulus

````{% endraw %}

## Method # 1: Using {% raw %}`dotenv-rails`{% endraw %}

If you are using the [dotenv-rails](https://github.com/bkeepers/dotenv/) gem, or another method of using {% raw %}`.env`{% endraw %} files, simply add the following to your {% raw %}`.env`{% endraw %} file:

{% raw %}```sh
export RUBYOPT='-W:no-deprecated -W:no-experimental'
```{% endraw %}

Then run the following in the root of the project:

{% raw %}```sh
source .env
```{% endraw %}

You should no longer be seeing the Ruby 2.7 deprecation warnings coming out of Rails! 🎉

## Method # 2: Prefixing commands

Another option you have for ignoring the Ruby 2.7 deprecation warnings is to prefix all of your Rails commands with {% raw %}`RUBYOPT='-W:no-deprecated -W:no-experimental'`{% endraw %}.

Example:

- {% raw %}`rails server`{% endraw %} would become {% raw %}`RUBYOPT='-W:no-deprecated -W:no-experimental' rails server`{% endraw %}
- {% raw %}`rails console`{% endraw %} would become {% raw %}`RUBYOPT='-W:no-deprecated -W:no-experimental' rails console`{% endraw %}
- etc.

This is obviously not ideal but it will work!

## Method # 3: Updating your environment

If you want to disable these deprecation messages everywhere, you can add the following to your {% raw %}`~/.zshrc`{% endraw %} or {% raw %}`~/.bashrc`{% endraw %}:

{% raw %}`export RUBYOPT='-W:no-deprecated -W:no-experimental'`{% endraw %}

This will disable deprecation and experimental feature warnings for all versions of Ruby, for all projects. I have heard of this creating issues for some so you may want to be careful using this method if you work on multiple apps that aren't on Ruby 2.7.

[View repo for this post](https://github.com/andrewmcodes/silence-ruby-2-7-deprecations)

Hopefully this helps! Happy coding!


*[This post is also available on DEV.](https://dev.to/andrewmcodes/hiding-ruby-2-7-deprecation-warnings-in-rails-6-2mil)*


<script>
const parent = document.getElementsByTagName('head')[0];
const script = document.createElement('script');
script.type = 'text/javascript';
script.src = 'https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/4.1.1/iframeResizer.min.js';
script.charset = 'utf-8';
script.onload = function() {
    window.iFrameResize({}, '.liquidTag');
};
parent.appendChild(script);
</script>
````
