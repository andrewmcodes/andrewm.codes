---
series: webpacker-6
featured: false
title: 'Webpacker 6: Troubleshooting Guide'
description: A (growing) collection of tools and techniques for debugging your Webpack(er) setup.   I highly recom...
urls:
  dev_to: 'https://dev.to/andrewmcodes/webpacker-6-troubleshooting-guide-pdl'
tags:
  - rails
  - webpacker
  - tutorial
  - debugging
categories: archived
date: '2020-12-23T22:16:57Z'
lastmod: '2022-01-22T02:21:04.739Z'
---

A (growing) collection of tools and techniques for debugging your Webpack(er) setup.

I highly recommend reading the [SurviveJS - Webpack 5 ebook for a real deep dive!][2].

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
[2]: https://survivejs.com/webpack/foreword/ "SurviveJS - Webpack 5 ebook for a real deep dive!"
