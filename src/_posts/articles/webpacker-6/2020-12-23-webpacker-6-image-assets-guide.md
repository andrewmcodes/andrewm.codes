---
title: 'Webpacker 6: Image Assets Guide'
published: true
description: How to use your image assets with Webpacker 6
excerpt: How to use your image assets with Webpacker 6
tags:
  - rails
  - tutorial
  - webpacker
  - ruby
coverimage: https://res.cloudinary.com/practicaldev/image/fetch/s--9KOpvZCa--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/10lu5ml7jlx9atv0q757.png
date: 2020-12-24T20:45:38.786Z
slug: image-assets-guide
categories:
  - posts
  - webpacker-6
order: 8
canonical_url: https://andrewm.codes/posts/webpacker-6/image-assets-guide/
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
<img src="<%= asset_pack_path 'media/images/icon.svg' %>" />
<img src="<%= asset_pack_path 'media/images/surf.jpg' %>" />
```

Reload your browser and you should see your images.

Note that `<%= asset_pack_path 'media/images/icon.svg' %>` only returns a string, so if you would rather inline your SVG files you will need to refer to the [Webpack Asset Modules documentation][1] and merge your changes into your Webpack context, as explained in [these Webpacker docs][2].

[1]:	https://webpack.js.org/guides/asset-modules/#inlining-assets
[2]:	https://github.com/rails/webpacker#webpack-configuration
