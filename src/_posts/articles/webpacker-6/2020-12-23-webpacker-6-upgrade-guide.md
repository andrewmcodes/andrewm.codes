---
title: 'Webpacker 6: Upgrade Guide'
published: true
description: How to install Webpacker 6 in a Ruby on Rails 6.1 Application
excerpt: How to install Webpacker 6 in a Ruby on Rails 6.1 Application
tags:
  - rails
  - tutorial
  - webpacker
  - ruby
coverimage: https://res.cloudinary.com/practicaldev/image/fetch/s--9KOpvZCa--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/10lu5ml7jlx9atv0q757.png
canonical_url: null
date: 2020-12-23T23:11:47.520Z
slug: upgrade-guide
categories:
  - posts
  - webpacker-6
order: 1
---

In this article, we will walkthrough how to upgrade to the latest version of [Webpacker][1], which is, at the time of writing,  `6.0.0.beta.1`.

Our upgrade process will begin with updating the Webpacker libraries, then we will update our configs and templates, and end up verifying that our new setup is working.

Let’s get started!

## Updating our `Gemfile`

Update the gem in your `Gemfile`:

```diff
# Gemfile

- gem 'webpacker', '~> 5.0'
+ gem 'webpacker', '~> 6.0.0.beta.1'
```

Next, run `bundle install` to install the new gem version. If all goes well, you should see `Using webpacker 6.0.0.beta.1 (was 5.2.1)` in the install output.

## Installing in our Application

Run the installation command, `bin/rails webpacker:install`, to generate the required configuration files, as well as update our `package.json`

## Update Document Head

Lastly, let's update `app/views/layouts/application.html.erb`. The docs for Webpacker v6 recommend using the `javascript_packs_with_chunks_tag` tag.

```diff
<%# app/views/layouts/application.html.erb %>

- <%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
- <%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
+ <%= javascript_packs_with_chunks_tag 'application', 'data-turbolinks-track': 'reload' %>
```

## Verify Installation

Run the Rails server (`bin/rails s`) and the Webpack Dev Server (`bin/webpack-dev-server`) via your preferred method. Two terminal tabs will work or create a [Procfile][2] and run via [overmind][3] or [foreman][4]. The Rails server will also compile your assets if the dev server is not running, but this is much slower vs running separate processes and not recommended.

Visit `http://localhost:3000` in your browser. If all's well, you should see the contents of `app/views/pages/home.html.erb`.

We can verify our JavaScript is getting loaded by adding the following to `app/javascript/packs/application.js`:

```js
// app/javascript/packs/application.js

console.log('Hello from Webpacker!')
```

Open the browser console and reload the page and you should see the message we added:

```js
[Log] Hello from Webpacker! (application-7fbebc85af7886af0a64.js, line 62)
```

## Summary

Congrats! You’re up and running with Webpacker 6!

Unfortunately you will quickly realize that your upgrade is not finished if you begin developing like you usually would with Webpacker.

Webpacker 6 requires you to add the [appropriate Webpack loaders][5] yourself, which is a breaking change from previous versions.

We will tackle that [in the next article!]({% link \_posts/articles/webpacker-6/2020-12-23-webpacker-6-css-loader.md %})

[1]:	https://github.com/rails/webpacker/releases "Webpacker"
[2]:	https://devcenter.heroku.com/articles/procfile
[3]:	https://github.com/DarthSim/overmind
[4]:	https://github.com/ddollar/foreman
[5]:	https://webpack.js.org/loaders/
