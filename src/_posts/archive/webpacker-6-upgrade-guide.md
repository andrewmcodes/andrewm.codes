---
series: webpacker-6
featured: false
title: 'Webpacker 6: Upgrade Guide'
description: 'This page has changed since first posted, refer to the changelog at the bottom.   In this article, w...'
urls:
  dev_to: 'https://dev.to/andrewmcodes/webpacker-6-upgrade-guide-3p6d'
tags:
  - rails
  - ruby
  - webpacker
  - tutorial
categories: archived
date: '2020-12-23T22:07:10Z'
lastmod: '2022-01-22T02:20:46.229Z'
---

> **This page has changed since first posted**, refer to the changelog at the bottom.

In this article, we will walkthrough how to upgrade to the latest version of [Webpacker][1], which is, at the time of writing, `6.0.0.beta.2`.

Our upgrade process will begin with updating the Webpacker libraries, then we will update our configs and templates, and end up verifying that our new setup is working.

Let’s get started!

## Updating our `Gemfile`

Update the gem in your `Gemfile`:

```diff
# Gemfile

- gem 'webpacker', '~> 5.0'
+ gem 'webpacker', '~> 6.0.0.beta.2'
```

Next, run `bundle install` to install the new gem version. If all goes well, you should see `Using webpacker 6.0.0.beta.2 (was 5.2.1)` in the install output.

## Installing in our Application

Run the installation command, `bin/rails webpacker:install`, to generate the required configuration files, as well as update our `package.json`

## Update Document Head

Lastly, let's update `app/views/layouts/application.html.erb`. The docs for Webpacker v6 recommend using the `javascript_packs_with_chunks_tag` tag.

```diff
<%%# app/views/layouts/application.html.erb %>

- <%%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
- <%%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
+ <%%= javascript_packs_with_chunks_tag 'application', 'data-turbolinks-track': 'reload' %>
```

## Verify Installation

Run the Rails server (`bin/rails s`) and the Webpack Dev Server (`bin/webpack-dev-server`) via your preferred method. Two terminal tabs will work or create a [Procfile][2] and run via [overmind][3] or [foreman][4]. The Rails server will also compile your assets if the dev server is not running, but this is much slower vs running separate processes and not recommended.

Visit `http://localhost:3000` in your browser. If all's well, you should see the contents of `app/views/pages/home.html.erb`.

We can verify our JavaScript is getting loaded by adding the following to `app/javascript/packs/application.js`:

```js
// app/javascript/packs/application.js

console.log("Hello from Webpacker!");
```

Open the browser console and reload the page and you should see the message we added:

```js
[Log] Hello from Webpacker! (application-7fbebc85af7886af0a64.js, line 62)
```

## Summary

Congrats! You’re up and running with Webpacker 6!

Unfortunately you will quickly realize that your upgrade is not finished if you begin developing like you usually would with Webpacker.

Webpacker 6 requires you to add the [appropriate Webpack loaders][5] yourself, which is a breaking change from previous versions.

We will tackle that [in the next article!](https://andrewm.codes/posts/webpacker-6/css-loaders/)

## Changelog

- [feat: updates for webpacker v6.0.0.beta.2](https://github.com/andrewmcodes/andrewm-codes-website/pull/11)

[1]: https://github.com/rails/webpacker/releases "Webpacker"
[2]: https://devcenter.heroku.com/articles/procfile
[3]: https://github.com/DarthSim/overmind
[4]: https://github.com/ddollar/foreman
[5]: https://webpack.js.org/loaders/
