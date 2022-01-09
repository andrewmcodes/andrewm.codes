---
series: "webpacker-6"
featured: false
title: "Webpacker 6: Image Asset Guide"
description: "In order to use your images and SVG files with Webpacker 6, you need to put them in the correct place..."
urls:
  dev_to: https://dev.to/andrewmcodes/webpacker-6-image-asset-guide-42hn
tags:
- rails
- webpacker
- tutorial
- svg
categories: tutorial
date: "2020-12-24T22:44:46Z"
lastmod: "2021-02-17T04:18:36Z"
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

Note that `<%%= asset_pack_path 'media/images/icon.svg' %>` only returns a string, so if you would rather inline your SVG files you will need to refer to the [Webpack Asset Modules documentation][1] and merge your changes into your Webpack context, as explained in [these Webpacker docs][2].

[1]: https://webpack.js.org/guides/asset-modules/#inlining-assets
[2]: https://github.com/rails/webpacker#webpack-configuration
