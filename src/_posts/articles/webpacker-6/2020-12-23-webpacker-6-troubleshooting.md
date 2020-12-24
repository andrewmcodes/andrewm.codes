---
title: 'Webpacker 6: Troubleshooting Guide'
published: true
description: Debugging techniques and tools you can use with Webpacker 6
excerpt: Debugging techniques and tools you can use with Webpacker 6
tags:
  - rails
  - tutorial
  - webpacker
  - debugging
coverimage: https://res.cloudinary.com/practicaldev/image/fetch/s--9KOpvZCa--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/10lu5ml7jlx9atv0q757.png
canonical_url: null
date: 2020-12-23T22:25:26.185Z
slug: troubleshooting-guide
categories:
  - posts
  - webpacker-6
order: 7
canonical_url: https://andrewm.codes/posts/webpacker-6/troubleshooting-guide/
---

## Locating the Issue

Use the network tab in your browser to view the CSS that’s being sent to the browser for clues.

## Cached Styles

If you update your styles but your UI does not change and there are no errors, it’s likely browser caching.

Hard reload after clearing your cache and you should see your changes.

To avoid these errors, import your styles into your JS pack vs. using `style-loader`.

## Tools

### Dashboards

- [Webpack-Dashboard][1]

[1]: https://github.com/FormidableLabs/webpack-dashboard "Webpack-Dashboard"
