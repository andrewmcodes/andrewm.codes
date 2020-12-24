---
title: 'Webpacker 6: Sass Loaders'
published: true
description: How to use SCSS and Sass with Webpacker 6
excerpt: How to use SCSS and Sass with Webpacker 6
tags:
  - rails
  - tutorial
  - webpacker
  - scss
coverimage: https://res.cloudinary.com/practicaldev/image/fetch/s--9KOpvZCa--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/10lu5ml7jlx9atv0q757.png
canonical_url: null
date: 2020-12-23T22:25:26.185Z
slug: sass-loaders
categories:
  - posts
  - webpacker-6
order: 5
canonical_url: https://andrewm.codes/posts/webpacker-6/sass-loaders/
---

In order to process `.scss` and `.sass` files with Webpacker 6, you need to add [sass-loader and sass][1].

> Note: This section builds on the CSS section

## Install

```bash
yarn add sass-loader sass
```

## Usage

**You should be able to use the same pack tag that you added for CSS.**

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

[1]:	https://webpack.js.org/loaders/sass-loader/

#rails #tutorial #webpacker #scss
