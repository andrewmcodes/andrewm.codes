---
series: null
featured: false
title: How to Deploy Your Bridgetown Site to Github Pages
description: It has never been easier to deploy your Bridgetown site to GitHub Pages thanks
  to a new bundled configuration in Bridgetown v1.0
tags:
  - bridgetown
  - github-pages
  - github-actions
categories: tutorial
date: "2022-03-23T07:46:39.094Z"
last_modified_at: "2022-03-23T07:47:00.109Z"
---

With the release of [Bridgetown version 1.0](https://www.bridgetownrb.com/release/reaching-1.0-next-generation-progressive-site-generator/) came several new [bundled configurations](https://www.bridgetownrb.com/docs/bundled-configurations) for deployment, in addition to other powerful new features.

I was personally able to introduce a bundled configuration for deploying to Vercel in [bridgetownrb/bridgetown#483.](https://github.com/bridgetownrb/bridgetown/pull/483) After the final v1 release, I was pouring over the changes and, to my delight, I discovered that a bundled configuration for GitHub Pages was added in [bridgetown/bridgetownrb#503](https://github.com/bridgetownrb/bridgetown/pull/503).

Before I explain why I was overjoyed with this addition from [Ayush](https://twitter.com/ayushn21), let's deploy a Bridgetown site to GitHub Pages using this new configuration to see how it works!

## Requirements

Make sure [Bridgetown v1.0 or higher is installed](https://www.bridgetownrb.com/docs), otherwise the `gh-pages` bundled configuration will not be available.

⚠️ This tutorial assumes you are creating a ["Project Site"](https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages#types-of-github-pages-sites). If you are trying to create a user or organization site, you may not need to make the configuration changes below.

## Getting Started

If you have an existing Bridgetown site you want to deploy to GitHub Pages, run `bin/bridgetown configure gh-pages` from the root of your project to add the necessary files and skip the following step.

If you do not have an existing site, let's create a new one with the `gh-pages` configuration.

```sh
bridgetown new bridgetown-gh-pages-demo -t erb -c gh-pages && cd bridgetown-gh-pages-demo
```

If done correctly, you will see the following output in your terminal, accompanied by further instructions: `🎉 A GitHub action to deploy your site to GitHub pages has been configured!`

## Updates for GitHub Pages

We need to make two updates to our site to make it work correctly on GitHub Pages as detailed in the configuration output.

The URL of our deployed site will be `https://<username>.github.io/<repository>/`, where `<repository>` acts as a base path for the site. For me, that URL was `https://andrewmcodes.github.io/bridgetown-gh-pages-demo/`.

First, we need to update the `base_path` in our Bridgetown config file `bridgetown.config.yml`:

```diff
- base_path: ""
+ base_path: "/bridgetown-gh-pages-demo"
```

Secondly, [esbuild](https://esbuild.github.io) is now the default build tool in Bridgetown v1.0, and we need to tell it that our `publicPath` is now prefixed with `/bridgetown-gh-pages-demo` in `esbuild.config.js`:

```diff
- const esbuildOptions = {}
+ const esbuildOptions = { publicPath: "/bridgetown-gh-pages-demo/_bridgetown/static" }
```

That should be all the setup we need to do!

⚠️ One thing you may need to check for on an existing site is that you are using `resource.relative_url` instead of passing the location directly to any anchor tags for example. `#relative_url` will correctly add the base path we configured in `bridgetown.config.yml` to the links that you will otherwise have to add manually.

## Pushing Our Work

Let's add and commit this code:

```sh
git add . && git commit -m "chore: initial commit"
```

Next, create your repository using your preferred method. I find myself reaching for the [GitHub CLI](https://cli.github.com/) these days:

```sh
gh repo create bridgetown-gh-pages-demo --public --source=. --push
```

If you set up the repository from the GitHub UI, don't forget to add the remote origin and push, which the CLI command above handles for us:

```sh
git remote add origin https://github.com/USERNAME/bridgetown-gh-pages-demo.git
git push -u origin main
```

## Configure GitHub Pages and Deploy

You may have noticed an action started automatically when you pushed your code, which kicked off a GitHub Pages deploy. Once the action completes successfully, we should have a branch named `gh-pages` with our static site contents.

The last thing we need to do is tell GitHub Pages to use the `gh-pages` branch as it's source in `Settings -> Pages`.

Navigate to the settings page and set the source from `None` to `gh-pages` and click save.

<img alt="GitHub Pages Public URL" src="<%= cloudinary_url 'v1648021946/posts/deploy-bridgetown-to-github-pages/20220323061751Z_Safari_Pages_cfmcb4', :medium %>" />

Once the automatic deployment completes, your site URL should be displayed! Navigate to it in your browser and verify everything works correctly.

## Success!

<img alt="GitHub Pages Public URL" src="<%= cloudinary_url 'v1648021947/posts/deploy-bridgetown-to-github-pages/20220323061936Z_Safari_Your_awesome_title_This_site_is_totally_awesome_a5kova', :medium %>" />

I want to give another big shoutout to [Ayush](https://twitter.com/ayushn21) for adding this bundled configuration to Bridgetown v1.0!

Why? Because now the former art that I had been (lazily) maintaining can be archived and taken off my plate. 🎉

## Farewell Old Code

In the summer of 2020, I created [bridgetown-gh-pages-action](https://github.com/andrewmcodes/bridgetown-gh-pages-action), which attempted to solve the same problem of making deploying your Bridgetown site to GitHub Pages automatic and seamless.

Unfortunately, as I discovered with many of the GitHub Actions I created earlier on, maintenance was a pain, it was not flexible, and the issues were specific to the users environment and almost impossible to debug.

With the introduction of the new `gh-pages` bundled configuration, I will be archiving this action and it will not receive any future updates.

## Final Thoughts

I am interested to see whether this configuration will cause similar issues and churn that I went through on this and several other actions now that it is in Bridgetown. The reality is that these actions are great at the golden path, but tend to fall over if the user has left that path.

By the way, if you are in this situation, you should be creating your own custom action with the library versions you need, not reaching for something off the shelf.

For now, I will be keeping my eyes on the issues to see if I can pitch in when the inevitable "bug" report comes in.
