---
series: webpacker-6
featured: false
title: 'Webpacker 6: SCSS/Sass Loaders'
description: 'In order to process .scss and .sass files with Webpacker 6, you need to add sass-loader and sass.   N...'
urls:
  dev_to: 'https://dev.to/andrewmcodes/webpacker-6-scss-sass-loaders-37p3'
tags:
  - rails
  - webpacker
  - tutorial
  - sass
categories: tutorial
date: '2020-12-23T22:15:46Z'
lastmod: '2022-01-09T13:35:58.207Z'
---

In order to process `.scss` and `.sass` files with Webpacker 6, you need to add [sass-loader and sass][1].

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

[1]: https://webpack.js.org/loaders/sass-loader/
