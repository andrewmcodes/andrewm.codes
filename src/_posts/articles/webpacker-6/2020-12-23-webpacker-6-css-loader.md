---
title: 'Webpacker 6: CSS Loaders'
published: true
description: How to use Vanilla CSS with Webpacker 6
excerpt: How to use Vanilla CSS with Webpacker 6
tags:
  - rails
  - tutorial
  - webpacker
  - css
coverimage: https://res.cloudinary.com/practicaldev/image/fetch/s--9KOpvZCa--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/10lu5ml7jlx9atv0q757.png
canonical_url: null
date: 2020-12-23T22:25:26.185Z
slug: css-loaders
categories:
  - posts
  - webpacker-6
order: 3
canonical_url: https://andrewm.codes/posts/webpacker-6/css-loaders/
---

In order to process `.css` files with Webpacker 6, you need to add [css-loader][1], [style-loader][2], and [mini-css-extract-plugin][3].

## Install

```bash
yarn add css-loader style-loader mini-css-extract-plugin css-minimizer-webpack-plugin
```

## Usage

Add a `stylesheet_packs_with_chunks_tag` or `stylesheet_pack_tag` to the document head.

Make sure you restart `bin/webpack-dev-server` after installing new loaders.

### Style Loader Example

```diff
<%# app/views/layouts/application.html.erb %>

+ <%= stylesheet_packs_with_chunks_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
<%= javascript_packs_with_chunks_tag 'application', 'data-turbolinks-track': 'reload' %>
```

### Extract Example

```diff
<%# app/views/layouts/application.html.erb %>

<%= javascript_packs_with_chunks_tag 'application', 'data-turbolinks-track': 'reload' %>
+ <%= stylesheet_pack_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
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

[1]:	(https://webpack.js.org/loaders/css-loader/
[2]:	https://webpack.js.org/loaders/style-loader/ "style-loader"
[3]:	https://github.com/webpack-contrib/mini-css-extract-plugin "mini-css-extract-plugin"
