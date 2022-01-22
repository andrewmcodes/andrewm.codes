---
series: webpacker-6
featured: false
title: 'Webpacker 6: Tailwind CSS 2.0 Integration'
description: 'In order to add Tailwind CSS 2.0 to your Rails 6 + Webpacker 6 application, you need PostCSS set up,...'
urls:
  dev_to: 'https://dev.to/andrewmcodes/webpacker-6-tailwind-css-2-0-integration-3oe6'
tags:
  - rails
  - webpacker
  - tailwindcss
  - tutorial
categories: archived
date: '2020-12-23T22:09:34Z'
lastmod: '2022-01-22T02:21:08.811Z'
---

In order to add Tailwind CSS 2.0 to your Rails 6 + Webpacker 6 application, you need PostCSS set up, plus a few additional steps.

Tailwind CSS has [detailed documentation on preprocessor usage][1] so refer to that for further setup.

> Note: This section builds on the PostCSS section

## Install

```bash
yarn add tailwindcss
```

### Add Tailwind CSS Config File

```bash
yarn tailwind init
```

### Update PostCSS Config

```diff
// postcss.config.js

module.exports = {
  plugins: [
    require('postcss-import'),
+   require('tailwindcss'),
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
touch app/javascript/stylesheets/base.css
echo "@import 'tailwindcss/base';" >> app/javascript/stylesheets/base.css
touch app/javascript/stylesheets/utilities.css
echo "@import 'tailwindcss/utilities';" >> app/javascript/stylesheets/utilities.css
touch app/javascript/stylesheets/components.css
echo "@import 'tailwindcss/components';" >> app/javascript/stylesheets/components.css
```

Next, add some CSS:

```diff
/* app/javascript/stylesheets/base.css */

@import "tailwindcss/base";

+ h1 {
+   font-size: 2.2em;
+   color: #2563eb;
+ }
+
+ p {
+   font-size: 1.2em;
+ }
```

Lastly, update `application.css`:

```css
/* app/javascript/packs/application.css */

@import "../stylesheets/base.css";
@import "../stylesheets/components.css";
@import "../stylesheets/utilities.css";
```

Reload your browser and your styles should be applied now with Tailwind CSS, and the Webpacker loader error should be gone.

[1]: https://tailwindcss.com/docs/using-with-preprocessors
