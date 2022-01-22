---
series: webpacker-6
featured: false
title: 'Webpacker 6: PostCSS Loaders'
description: 'In order to process .pcss files with Webpacker 6, you need to add postcss-loader. I am also going to...'
urls:
  dev_to: 'https://dev.to/andrewmcodes/webpacker-6-postcss-loaders-4ajd'
tags:
  - rails
  - webpacker
  - tutorial
  - postcss
categories: archived
date: '2020-12-23T22:14:19Z'
lastmod: '2022-01-22T02:21:18.364Z'
---

In order to process `.pcss` files with Webpacker 6, you need to add [postcss-loader][1]. I am also going to add PostCSS 8 support.

> Note: This section builds on the CSS section

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

[1]: https://webpack.js.org/loaders/postcss-loader/ "postcss-loader"
