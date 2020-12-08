---
categories:
  - posts
title: 'Rails Coverage Tools: Coverband'
date: '2020-02-22T06:18:25.427Z'
excerpt: >-
  Coverband   According to their documentation, Coverband is:   A gem to measure
  production co...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--S4UQ1SKp--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/mdxdk1kcmofl5upo23v3.jpg
comments_count: 6
positive_reactions_count: 50
tags:
  - rails
  - codequality
  - ruby
  - tutorial
dev_to_url: 'https://dev.to/andrewmcodes/rails-coverage-tools-coverband-54mg'
layout: post
---

# Coverband

According to their documentation, Coverband is:

> A gem to measure production code usage, showing a counter for the number of times each line of code that is executed. Coverband allows easy configuration to collect and report on production code usage. (...) The primary goal of Coverband is giving deep insight into your production runtime usage of your application code, while having the least impact on performance possible

TL;DR

Coverband gives you insights into what code is being loaded in your Rails application, which you can also think of as code that is being used by the application. This can be a very useful tool for refactoring, and removing code that is no longer used or needed.

## Demo

I will be working from [this repo](https://github.com/andrewmcodes/rails_coverage_tools). You can look through that code, or you can follow along by using [my Rails app template](https://github.com/andrewmcodes/rails_template) I used to create this project.

The rest of the tutorial will assume you already have a functioning Rails app!

## Installation

Add the Coverband gem to your {% raw %}`Gemfile`{% endraw %}. I personally decided to keep it in my development group, because I didn't see any value in having the dashboard available in production.

{% raw %}```ruby

# Gemfile

gem "coverband", group: :development

# or

group :development do
gem "coverband"
end

````{% endraw %}

Then run:

{% raw %}```sh
bundle install
```{% endraw %}

## Configuration

### Redis

Coverband stores coverage data in Redis. According to the documentation, the Redis endpoint is looked for in this order:

{% raw %}```ruby
ENV['COVERBAND_REDIS_URL']
ENV['REDIS_URL']
localhost
```{% endraw %}

You can also specifically set this in a Coverband initializer file. If you are using the template that I’m using then you should be all set, otherwise make sure you are running Redis locally, bundle the {% raw %}`redis`{% endraw %} gem, and your app can access it.

### Initializer

Let's configure the gem. Create an initializer file for Coverband, which should look like the following:

{% raw %}```ruby
# config/coverband.rb

Coverband.configure do |config|
  config.ignore += ["config/application.rb",
                    "config/boot.rb",
                    "config/puma.rb",
                    "bin/*",
                    "config/environments/*",
                    "lib/tasks/*",]
end
```{% endraw %}

These settings just tell Coverband to ignore our specified files and paths.

### Route

Now, lets add a route for coverband so we can view the web dashboard:

{% raw %}```ruby
# config/routes.rb

Rails.application.routes.draw do
  mount Coverband::Reporters::Web.new, at: "/coverband" if Rails.env.development?
end
```{% endraw %}

It is worth noting that if you are running this tool in production, you should protect this route with proper authentication.

## Usage

We should be all set to see what Coverband can provide us!

Fire up the Rails server and navigate to {% raw %}`localhost:3000/coverband`{% endraw %}

Alternatively, you can run the following Rake task and static files will be created in {% raw %}`coverage/`{% endraw %}. I would recommend making sure this directory is added to your {% raw %}`.gitignore`{% endraw %}.

{% raw %}```sh
rake coverband:coverage
```{% endraw %}

You should now be seeing is Coverband's mountable web interface to easily view Coverband reports.

![coverband_1](https://dev-to-uploads.s3.amazonaws.com/i/k3eqawgyobre6zas94m1.jpg)

If we click on a file with 0% coverage, you will see the following message:

>This file was never loaded during app runtime or loading (or was loaded before Coverband loaded)!

Basically this mean the code inside the file has not been loaded, and therefore not used.

If we click on a file with partial coverage, you should see something like:

![coverband_2](https://dev-to-uploads.s3.amazonaws.com/i/kluvsd2sagfwpbjz8es3.jpg)

This view will highlight the lines that have been used, and those that haven't. Take care before you start ripping out code though, it's possible that you just haven't exercised that code yet.

In the {% raw %}`posts_controller`{% endraw %} file in my example above, the code inside our {% raw %}`new`{% endraw %} and {% raw %}`create`{% endraw %} methods is not being used. I am going to open up the UI, and create a new post. You will notice that the coverage report looks a little different now:

![coverband_3](https://dev-to-uploads.s3.amazonaws.com/i/smks7r65kpjlpfan8cxj.jpg)

It is important to exercise some due diligence before removing code that Coverband flags. In the example above, after some investigation I realized I in fact do not need {% raw %}`config/spring.rb`{% endraw %} because I am not using {% raw %}`spring`{% endraw %} in this project. This is the power of this library, the ability to point you towards areas in your codebase that may be safe to remove; however, if I had removed the flagged code in the {% raw %}`posts_controller`{% endraw %} then I would be in some trouble.

### Tracking Gems

It is also possible to use Coverband to track gem usage. This is still in experimental stages and not recommended for production according to the docs.

To see it in action, first let's update our initializer:

{% raw %}```ruby
# config/initializers/coverband.rb

Coverband.configure do |config|
  config.track_gems = true
  config.ignore += ["config/application.rb",
                    "config/boot.rb",
                    "config/puma.rb",
                    "bin/*",
                    "config/environments/*",
                    "lib/tasks/*",]
end

```{% endraw %}

According to the docs:

> When tracking gems, it is important that Coverband# start is called before the gems to be tracked are required. The best way to do this is to require coverband before Bundle.require is called

So lets update {% raw %}`application.rb`{% endraw %} to make sure coverband is loaded before {% raw %}`Bundler.require`{% endraw %} is called:

{% raw %}```ruby
# config/application.rb

require "coverband"
Bundler.require(*Rails.groups)
```{% endraw %}

Restart the Rails server and you should now have a gem tab if you navigate back to {% raw %}`localhost:3000/coverband`{% endraw %}.

![coverband_4](https://dev-to-uploads.s3.amazonaws.com/i/nayxiegisac553pbk0wu.jpg)

This can help give you insight into gems that may be safe to remove.

### Tracking Views

There is a config option to watch your views, but it was not working for me on {% raw %}`Rails 6.0.2.1`{% endraw %} and {% raw %}`Ruby 2.7`{% endraw %} so I won't go into it now.

See [the advanced configuration documentation](https://github.com/danmayer/coverband# advanced-config) for more information.

## Summary

Coverband is a great tool to help you find code in your Rails app that may be safe to remove. The tool is not perfect though, so take care that the code can actually be safely removed. I personally used this tool on [CodeFund's](https://github.com/gitcoinco/code_fund_ads) codebase and found some code that could be removed! And who doesn't like deleting code? Definitely recommend adding this tool to your tool belt.

#### Links

- [coverband gem](https://github.com/danmayer/coverband# advanced-config)
- [rails template](https://github.com/andrewmcodes/rails_template)
- [repo for this post](https://github.com/andrewmcodes/rails_coverage_tools)

Happy Coding!


*[This post is also available on DEV.](https://dev.to/andrewmcodes/rails-coverage-tools-coverband-54mg)*


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
