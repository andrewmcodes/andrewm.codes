---
categories:
  - post
title: How to inline SVG files in your Bridgetown site
date: '2020-07-21T20:18:38.141Z'
excerpt: >-
  This is a short tutorial to showcase how you can quickly integrate
  bridgetown-inline-svg into your Br...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--pVeuSCKC--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/5nfy4qo3whqn3g01vbzv.png
comments_count: 0
positive_reactions_count: 9
tags:
  - tutorial
  - beginners
  - bridgetown
  - ruby
dev_to_url: >-
  https://dev.to/andrewmcodes/how-to-inline-svg-files-in-your-bridgetown-site-45ag
layout: post
---

This is a short tutorial to showcase how you can quickly integrate [{% raw %}`bridgetown-inline-svg`{% endraw %}](https://github.com/andrewmcodes/bridgetown-inline-svg) into your [Bridgetown](https://www.bridgetownrb.com) site to easily inline your SVG assets when you build your site.

The code for this tutorial can be found at: [andrewmcodes/bridgetown-inline-svg-starter](https://github.com/andrewmcodes/bridgetown-inline-svg-starter)

This tutorial is using version {% raw %}`1.1.0`{% endraw %} of {% raw %}`bridgetown-inline-svg`{% endraw %}. If you are already using this plugin, you may need to upgrade the gem.

Let's get started!

## Quickstart

To follow along without building the project yourself, just open in Gitpod via the button below, and open the browser preview on port 4000 after dependencies are installed and Bridgetown starts up.

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/# https://github.com/andrewmcodes/bridgetown-inline-svg-starter)

## Setup

This tutorial will assume you have Ruby, Node, and the [bridgetown gem](https://rubygems.org/gems/bridgetown) installed locally.

For detailed instructions on getting Bridgetown set up on your local machine, take a look at the [Bridgetown Getting Started Documentation](https://www.bridgetownrb.com/docs/) and the [Bridgetown Installation Guides](https://www.bridgetownrb.com/docs/installation). I also go into a little more depth in [this post detailing how to setup NetlifyCMS on your Bridgetown site.](https://dev.to/andrewmcodes/creating-a-blog-with-bridgetown-and-netlify-cms-1d1a)

## Creating a new Bridgetown site

The first thing we are going to do is generate a new Bridgetown site.

Run the following command in your terminal:

{% raw %}

```bash
bridgetown new bridgetown-inline-svg-starter
cd bridgetown-inline-svg-starter
```

{% endraw %}

Our new site has been generated! :tada:

### Add [`bridgetown-inline-svg`](https://github.com/andrewmcodes/bridgetown-inline-svg) plugin

The next thing we are going to do is add the [`bridgetown-inline-svg`](https://github.com/andrewmcodes/bridgetown-inline-svg) gem.

Run the following command in your terminal to add the plugin to your site's Gemfile:

```bash
bundle add bridgetown-inline-svg -g bridgetown_plugins
```

or manually:

```ruby
# Gemfile

group :bridgetown_plugins do
  gem "bridgetown-inline-svg", "~> 1.1.0"
end
```

### Add SVG files

Create a folder for your SVG files under `src/`. You can name or nest it however you like. I am just going to create a folder named `assets`:

```bash
mkdir src/assets
```

Then get your SVG files! This library works great with anything from illustrations to icons.

For the purpose of this demo, I downloaded two illustrations from [unDraw](https://undraw.co) by [Katerina Limpitsouni](https://twitter.com/ninaLimpi), which is a great resource of open source illustrations, and one icon from [Heroicons](https://github.com/refactoringui/heroicons), an open source SVG icon library from [Adam Wathan](https://adamwathan.me) and [Steve Schoger](https://www.steveschoger.com).

You can download my assets [here](https://github.com/andrewmcodes/bridgetown-inline-svg-starter/releases/download/v1.0.0/assets.zip).

My project `src/assets` folder now looks like:

```diff
|-- bridgetown
    |-- src
+   |   |-- assets
+   |       |-- mail.svg
+   |       |-- undraw_content_creator.svg
+   |       |-- undraw_design_components.svg
```

## Using the plugin

Let's take a look at what we have right now. Run {% raw %}`yarn start`{% endraw %} in your terminal and open {% raw %}`http://localhost:4000`{% endraw %} in your browser.

Your should see following in:

![Default Bridgetown Site](https://dev-to-uploads.s3.amazonaws.com/i/m9dg93scfne9srinnpkw.jpg)

### Pages

> "Pages are the most basic building block for content.." [Bridgetown Pages Documentation](https://www.bridgetownrb.com/docs/pages)

Let's add a simple full-width SVG to our home page. Add the following to {% raw %}`src/index.md`{% endraw %}, but replace my filepath with your own:

{% raw %}```liquid
{% svg "assets/undraw_design_components.svg" width="100%" %}

````{% endraw %}

This will produce something like:

![Home page with illustration](https://dev-to-uploads.s3.amazonaws.com/i/sd27459kmiiqxx10ar36.jpg)

### Collections

> "Collections are a great way to group related content..." [Bridgetown Collections Documentation](https://www.bridgetownrb.com/docs/collections)

Let's add a simple full-width SVG to the blog post Bridgetown generated for us. Add the following to {% raw %}`src/_posts/2020-07-20-welcome-to-bridgetown.md`{% endraw %} (the date prefix will be whatever date you generated the project):

{% raw %}```liquid
{% svg "assets/undraw_content_creator.svg" width="100%" height="280" %}
```{% endraw %}

Navigate to the post by going to {% raw %}`http://localhost:4000/posts/`{% endraw %} and choose your post. It will look something like this:

![Post page with illustration](https://dev-to-uploads.s3.amazonaws.com/i/gfd9xw5cq38rxtoohtbj.jpg)

### Components

> "A component is a reusable piece of template logic (sometimes referred to as a “partial”) that can be included in any part of the site..." [Bridgetown Components Documentation](https://www.bridgetownrb.com/docs/components)

Let's add an icon to our footer component. Add the following to {% raw %}`src/_components/footer.liquid`{% endraw %}:

{% raw %}```diff
<footer>
- Contact me at {{ metadata.email }}
+ {% svg "assets/mail.svg" style="color:# 6c63ff;" height="1.5rem" %}
+ <p>{{ metadata.email }}</p>
</footer>
```{% endraw %}

Your footer should now look something like:

![Footer icon](https://dev-to-uploads.s3.amazonaws.com/i/9e6z1wjnwsot2hzl9m94.jpg)

## Attributes

You can pass any valid SVG attribute to the plugin. If the attribute you pass in is already set in your SVG markup, the plugin will __override it__.

Here are a few examples based on usage above:

### Width and Height

{% raw %}```liquid
{% svg "path/to/my.svg" width="100%" %}
```{% endraw %}

Adding {% raw %}`width="100%"`{% endraw %} as an argument will change our output to:

{% raw %}```html
<svg width="100%" height="100%"></svg>
```{% endraw %}

Height is automatically set to match width if omitted because IE11 won't use the viewport attribute to calculate the image's aspect ratio.

If you don't want the width and height to match, set both:


{% raw %}```liquid
{% svg "path/to/my.svg" width="100%" height=240 %}
```{% endraw %}

produces:

{% raw %}```html
<svg width="100%" height="240"></svg>
```{% endraw %}

### Style

Set or override inline styles on your SVG with the {% raw %}`style`{% endraw %} attribute:

{% raw %}```liquid
{% svg "path/to/my.svg" style="color:# 6c63ff;" %}
```{% endraw %}

produces:

{% raw %}```html
<svg style="color:# 6c63ff;"></svg>
```{% endraw %}

### Classes

Set or override CSS classes on your SVG with the {% raw %}`class`{% endraw %} attribute:

{% raw %}```liquid
{% svg "path/to/my.svg" class="class-1 class-2" %}
```{% endraw %}

produces:

{% raw %}```html
<svg class="class-1 class-2"></svg>
```{% endraw %}

## Wrap up

From this point, you can continue adding SVGs to your site and the plugin will inline them when Bridgetown builds.

We didn't cover it in this post, but [the plugin can also optimize your SVGs as well](https://github.com/andrewmcodes/bridgetown-inline-svg# optional-configuration-options). View the [README](https://github.com/andrewmcodes/bridgetown-inline-svg) for the full documentation.

If you encounter any issues or find a bug with the plugin, feel free to report it on the [repository](https://github.com/andrewmcodes/bridgetown-inline-svg).

### Want to learn more?

Check out [my website](https://www.andrewm.codes) or [sign up for my newsletter](https://andrew.rubyists.dev) for more Bridgetown content!

Happy coding!

*[This post is also available on DEV.](https://dev.to/andrewmcodes/how-to-inline-svg-files-in-your-bridgetown-site-45ag)*


<script>
const parent = document.getElementsByTagName('head')[0];
const script = document.createElement('script');
script.type = 'text/javascript';
script.src = 'https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/4.1.1/iframeResizer.min.js';
script.charset = 'utf-8';
script.onload = function() {
    window.iFrameResize({}, '.liquidTag');
};
parent.appendChild(script);
</script>
````
