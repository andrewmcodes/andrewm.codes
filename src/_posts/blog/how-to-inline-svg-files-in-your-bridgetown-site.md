---
title: How to inline SVG files in your Bridgetown site
description: A short tutorial on how to inline SVG files in your Bridgetown site with
  bridgetown-svg-inliner.
urls:
  dev_to: https://dev.to/andrewmcodes/how-to-inline-svg-files-in-your-bridgetown-site-45ag
tags:
  - bridgetown
  - ruby
  - svg
category: tutorial
date: 2020-07-21T00:52:25Z
last_modified_at: 2022-01-29T17:01:41.583Z
---

A short tutorial on how to use [bridgetown-svg-inliner](https://github.com/ayushn21/bridgetown-svg-inliner) to inline SVG assets on your [Bridgetown](https://bridgetownrb.com) website.

Previously this post was about [andrewmcodes/bridgetown-inline-svg](https://github.com/andrewmcodes/bridgetown-inline-svg) but that plugin has since been put into maintenance mode in favor of this MIT licensed library by [Ayush Newatia.](https://twitter.com/ayushn21)

## Prerequisites

This tutorial assumes that you already have a Bridgetown website up and running. If you don't, check out [Bridgetown's Quick Instructions](https://www.bridgetownrb.com/docs/#quick-instructions) for instructions on how to generate your first site.

## Install

Run the following command to install the [plugin](https://github.com/ayushn21/bridgetown-svg-inliner) in your site:

```bash
bundle add "bridgetown-svg-inliner" -g bridgetown_plugins
```

## Usage

Bridgetown creates an images folder by default at `src/images`, which you can use to store your SVG assets or you can create your own folder like `assets`, just make sure it is nested under `src/`.

For this tutorial, I used the annotation outline icon from [Heroicons](https://heroicons.com).

### Basic Usage

Create a SVG called `icon.svg` at `src/images/icon.svg` and call it using the Ruby helper or Liquid tag:

```erb
<!-- ERB -->
<%%= svg "/images/icon.svg" %>
```

```liquid
<!-- Liquid -->
{% svg "/images/icon.svg" %}
```

This will inline the SVG as is in your file once the page renders.

## Advanced Usage

You can pass options to the plugin which will then be applied to the resulting element. If it already exists in your SVG file, it will be overwritten.

For example, this snippet:

```erb
<!-- ERB -->
<%%= svg "/images/icon.svg", class: "foo", width: "100%" %>
```

```liquid
<!-- ERB -->
{% svg "/images/icon.svg", class: "foo", width: "100%" %}
```

will result in the following HTML:

```html
<svg xmlns="http://www.w3.org/2000/svg" class="foo" fill="none" viewBox="0 0 24 24" stroke="currentColor" width="100%">
  <!-- ... -->
</svg>
```

## Reference

- [ayushn21/bridgetown-svg-inliner](https://github.com/ayushn21/bridgetown-svg-inliner)
