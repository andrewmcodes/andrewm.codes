---
series: webpacker-6
featured: false
title: 'Webpacker 6: CSS Loaders'
description: 'Processing CSS files with Webpacker 6 requires css-loader, style-loader, and mini-css-extract-plugin to be installed.'
urls:
  dev_to: 'https://dev.to/andrewmcodes/webpacker-6-css-loaders-28hb'
tags:
  - rails
  - webpacker
  - tutorial
  - css
categories: archived
date: '2020-12-23T22:12:55Z'
lastmod: '2022-01-22T02:22:16.732Z'
---

In order to process `.css` files with Webpacker 6, you need to add [css-loader][1], [style-loader][2], and [mini-css-extract-plugin][3].

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

## Changelog

- [chore: add css-minimizer-webpack-plugin](https://github.com/andrewmcodes/andrewm-codes-website/pull/12/commits/6b50b3e1a08236a09cd836c97066ddd4e3b76eed)

[1]: (https://webpack.js.org/loaders/css-loader/
[2]: https://webpack.js.org/loaders/style-loader/ "style-loader"
[3]: https://github.com/webpack-contrib/mini-css-extract-plugin "mini-css-extract-plugin"
[4]: https://webpack.js.org/plugins/css-minimizer-webpack-plugin "css-minimizer-webpack-plugin"
