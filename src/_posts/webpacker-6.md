---
title: "Webpacker 6"
description: "Archived upgrade guide for Webpacker 6"
category: tutorial
tags:
  - rails
  - webpacker
date: 2020-12-23T22:00:26Z
last_modified_at: 2022-06-01 22:17:33
---

Webpacker was officially retired before the official v6.0.0 was released following [the release of Rails 7.](https://rubyonrails.org/2021/12/15/Rails-7-fulfilling-a-vision) [Shakapacker](https://github.com/shakacode/shakapacker) is the official, actively maintained successor to Webpacker now.

Since the final version was never released, this post has been archived and will not receive further updates. The original upgrade guide was in multiple steps, but have been combined here for convenience.

---

Before we start the upgrade process for Webpacker 6, we are going to create a small demo application for us to work on.

If you are upgrading an existing app or not using this series as a tutorial, you can skip this step! We will begin the formal upgrade process in the next article.

## Generate a new Rails app

First we will generate new Ruby on Rails app:

```sh
rails new webpacker_6 --skip-sprockets --skip-spring --skip-webpack-install --skip-bundle
cd webpacker_6
```

- `--skip-sprockets`: Skip Sprockets files
- `--skip-spring`: Don't install Spring application preloader
- `--skip-bundle`: Don't run bundle install
- `--skip-webpack-install`: Don't run Webpack install

### Setup the Database

```sh
bin/rails db:prepare
```

### Turn off asset scaffolding

Prevent Rails from creating asset files when running the generators and scaffolds:

```diff
# config/application.rb

# ...
module Webpacker6
  class Application < Rails::Application
    config.load_defaults 6.1
+    config.generators do |g|
+      g.assets false
+    end
  end
end
```

## Add Pages Controller

Generate pages controller with a home action:

```sh
bin/rails g controller pages home
```

## Add Root Route

Set `pages#home` as the root route:

```diff
# config/routes.rb

Rails.application.routes.draw do
  get 'pages/home'
+  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
```

> Note: Because we skipped the Webpacker install task, you will get an error if you try to start the application as is. We will fix that in the next article.

---

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

console.log("Hello from Webpacker!")
```

Open the browser console and reload the page and you should see the message we added:

```js
[Log] Hello from Webpacker! (application-7fbebc85af7886af0a64.js, line 62)
```

---

In order to process `.css` files with Webpacker 6, you need to add [css-loader][6], [style-loader][7], and [mini-css-extract-plugin][8].

## Install

```bash
yarn add css-loader style-loader mini-css-extract-plugin
```

## Usage

Add a `stylesheet_packs_with_chunks_tag` or `stylesheet_pack_tag` to the document head.

Make sure you restart `bin/webpack-dev-server` after installing new loaders.

### Style Loader Example

```diff
<%%# app/views/layouts/application.html.erb %>

+ <%%= stylesheet_packs_with_chunks_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
<%%= javascript_packs_with_chunks_tag 'application', 'data-turbolinks-track': 'reload' %>
```

### Extract Example

```diff
<%%# app/views/layouts/application.html.erb %>

<%%= javascript_packs_with_chunks_tag 'application', 'data-turbolinks-track': 'reload' %>
+ <%%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
```

```diff
// app/javascript/packs/application.js

+ import "./application.css"
```

## Verify

> Note: Make sure you restart the dev server!

Let’s create a new file for our CSS:

```diff
touch app/javascript/packs/application.css
```

Next, add some CSS:

```css
/* app/javascript/packs/application.css */

h1 {
  font-size: 2.2em;
  color: #2563eb;
}

p {
  font-size: 1.2em;
}
```

Reload your browser and your styles should be applied now, and the Webpacker loader error should be gone.

---

In order to process `.pcss` files with Webpacker 6, you need to add [postcss-loader][10]. I am also going to add PostCSS 8 support.

## Install

```bash
yarn add postcss-loader postcss@latest autoprefixer@latest postcss-import@latest
```

### Add PostCSS Config File

```bash
touch postcss.config.js
```

```bash
// postcss.config.js

module.exports = {
  plugins: [
    require('postcss-import'),
    require('autoprefixer')
  ]
}
```

## Usage

**You should be able to use the same pack tag that you added for CSS.**

Make sure you restart `bin/webpack-dev-server` after installing new loaders.

### Style Loader Example

```diff
<%%# app/views/layouts/application.html.erb %>

+ <%%= stylesheet_packs_with_chunks_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
<%%= javascript_packs_with_chunks_tag 'application', 'data-turbolinks-track': 'reload' %>
```

### Extract Example

```diff
<%%# app/views/layouts/application.html.erb %>

<%%= javascript_packs_with_chunks_tag 'application', 'data-turbolinks-track': 'reload' %>
+ <%%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
```

```diff
// app/javascript/packs/application.js

+ import "./application.css"
```

## Verify

> Note: Make sure you restart the dev server!

Let’s create a new PostCSS file:

```bash
mkdir app/javascript/stylesheets
touch app/javascript/stylesheets/base.pcss
```

Next, add some CSS:

```css
/* app/javascript/stylesheets/base.pcss */

h1 {
  font-size: 2.2em;
  color: #2563eb;
}

p {
  font-size: 1.2em;
}
```

Lastly, update `application.css`:

```css
/* app/javascript/packs/application.css */

@import "../stylesheets/base.pcss";
```

Reload your browser and your styles should be applied now, and the Webpacker loader error should be gone.

---

In order to process `.scss` and `.sass` files with Webpacker 6, you need to add [sass-loader and sass][11].

> Note: This section builds on the [CSS section](https://andrewm.codes/blog/webpacker-6-css-loaders/)

## Install

```bash
yarn add sass-loader sass
```

## Usage

**You should be able to use the same pack tag that you added for CSS.**

Make sure you restart `bin/webpack-dev-server` after installing new loaders.

### Style Loader Example

```diff
<%%# app/views/layouts/application.html.erb %>

+ <%%= stylesheet_packs_with_chunks_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
<%%= javascript_packs_with_chunks_tag 'application', 'data-turbolinks-track': 'reload' %>
```

### Extract Example

```diff
<%%# app/views/layouts/application.html.erb %>

<%%= javascript_packs_with_chunks_tag 'application', 'data-turbolinks-track': 'reload' %>
+ <%%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
```

```diff
// app/javascript/packs/application.js

+ import "./application.scss"
```

## Verify

> Note: Make sure you restart the dev server!

Let’s create a new SCSS file:

```bash
touch app/javascript/packs/application.scss
```

Next, add some SCSS:

```css
/* app/javascript/packs/application.scss */

$body-background: #fafafa;
$body-color: #444;

body {
  background: $body-background;
  color: $body-color;
  font-family: sans-serif;
}

h1,
nav,
footer {
  text-align: center;
}

main {
  margin: 4rem auto;
  max-width: 60rem;
}
```

Reload your browser and your styles should be applied now, and the Webpacker loader error should be gone.

---

In order to use your images and SVG files with Webpacker 6, you need to put them in the correct place and import them into your context.

## Install

We should be good here.

## Usage

### Add Assets

```sh
mkdir -p app/javascript/media/images
```

### Require Context

```diff
// app/javascript/packs/application.js
+
+ function importAll(r) {
+  r.keys().forEach(r);
+ }
+ // Add relevant file extensions as needed below.
+ // I'm sure there is a better way :shrug:
+ importAll(require.context('../media/images/', true, /\.(svg|jpg)$/));
```

## Verify

> Note: Restart the dev server for good luck!

Add an SVG and PNG into `app/javascript/media/images`

In one of your views, add two image tags:

```erb
<img src="<%%= asset_pack_path 'media/images/icon.svg' %>" />
<img src="<%%= asset_pack_path 'media/images/surf.jpg' %>" />
```

Reload your browser and you should see your images.

Note that `<%%= asset_pack_path 'media/images/icon.svg' %>` only returns a string, so if you would rather inline your SVG files you will need to refer to the [Webpack Asset Modules documentation][12] and merge your changes into your Webpack context, as explained in [these Webpacker docs][13].

[2]: https://devcenter.heroku.com/articles/procfile
[3]: https://github.com/DarthSim/overmind
[4]: https://github.com/ddollar/foreman
[6]: https://webpack.js.org/loaders/css-loader/
[7]: https://webpack.js.org/loaders/style-loader/ "style-loader"
[8]: https://github.com/webpack-contrib/mini-css-extract-plugin "mini-css-extract-plugin"
[10]: https://webpack.js.org/loaders/postcss-loader/ "postcss-loader"
[11]: https://webpack.js.org/loaders/sass-loader/
[12]: https://webpack.js.org/guides/asset-modules/#inlining-assets
[13]: https://github.com/rails/webpacker#webpack-configuration
