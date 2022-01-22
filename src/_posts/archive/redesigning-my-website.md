---
series: null
featured: false
title: 'Redesigning my website '
description: My personal website - andrewm.codes has gone through many iterations over the years. Some may view my...
urls:
  dev_to: 'https://dev.to/andrewmcodes/redesigning-my-website-4lli'
tags:
  - webdev
  - bridgetown
  - ruby
  - strapi
categories: blog
date: '2021-02-17T03:07:25Z'
lastmod: '2022-01-22T02:23:54.733Z'
---

My personal website - [andrewm.codes](https://andrewm.codes/) has gone through many iterations over the years. Some may view my constant tinkering as a waste of time, and it probably is, but I've come to realize that I really enjoy using it as a playground to test new technologies and new ideas. The problem with this approach though is that it continually became an excuse for not writing actual content. With this iteration of the site, I decided to put content creation first and tinkering second.

## History

My site has existed on multiple domains using various technologies since 2016. I won't bore you with all of the details but here is a short list of _some_ of the tech I've used to build other versions:

1. Plain HTML & CSS
2. [Nuxt](https://nuxtjs.org/)
3. [Gatsby](https://www.gatsbyjs.com)
4. [Stackbit](https://www.stackbit.com)
5. [Bridgetown](https://www.bridgetownrb.com)

## Planning

One of the reasons most of my other sites ended up being unmaintainable or not having certain features that I wanted was simply due to a lack of planning. This time I wanted things to be different.

### Choosing a Framework

As a Rubyist, I had always struggled to wrap my brain around JavaScript static site generators because of what I viewed as unnecessary complexity and dependency hell; however, I continued to use them over something like [Jekyll](https://jekyllrb.com) because I wanted to use more modern tools like [Tailwind CSS](https://tailwindcss.com) and build my views with components.

Enter [Bridgetown](https://www.bridgetownrb.com).

I'm not going to go over what Bridgetown is right now, but the key features it had that I wanted were Ruby, markdown, components, ability to use modern JS tooling easily, API for content generation, and easily customizable. I definitely encourage you to give it a look if you're considering a site redesign.

### Setting Priorities

I sat down and chose a few things I really cared about when it came to the content and architecture of the site:

- Owning my content
- Ability to publish content remotely
- Great developer experience
- Scriptable

While I didn't follow this 100% of the time, my general goal was to only work on things in service to these main goals.

Data design is something I will discuss below but I wanted to call out the fact I should have spent more time settling on the shape of the data and exactly what content I wanted before diving straight into building with fake data. What I failed to recognize at first is that the data structure for your static site is just as important as for your webapp, and careful upfront design can save lots of time and headache.

## The Stack

- Framework: [Bridgetown](https://www.bridgetownrb.com)
- Template Language: [ERB](https://www.bridgetownrb.com/docs/erb-and-beyond)
- Frontend Build Tool: [Snowpack](https://www.snowpack.dev)
- CSS: [Tailwind CSS](https://tailwindcss.com) w/ Darkmode!
- JavaScript Sprinkles: [Stimulus](https://stimulus.hotwire.dev)
- Performance: [Turbo](https://turbo.hotwire.dev)
- Image Management: [Cloudinary](https://cloudinary.com/)
- Hosting: [Vercel](https://vercel.com)
- Analytics: [Plausible](https://plausible.io)

## Content Creation Workflow

Bridgetown gives you access to [powerful ways to dynamically build pages and date](https://www.bridgetownrb.com/docs/plugins#http-requests-and-the-document-builder) so regardless of where the data comes from, implementation is pretty straight forward especially since you can leverage gems of your choosing.

> Warning: overkill solution ahead

All of the site data, except for blog articles, are saved in a [Strapi headless CMS](https://strapi.io/) self-hosted on [Heroku](https://heroku.com) backed by a PostgreSQL database. A bit of work to get up and running but it offers me:

- Robust REST Api with automically generated Swagger docs
- GraphQL endpoint with API methods
- Media file management with automatic Cloudinary uploads

Ultimately this is one piece I may replace in the future but its an easy way to get up and running fast with a headless CMS and allow you to own the data. This was the only option I found that gave me all the features I wanted out of the box. I tried several data sources including Forestry, DatoCMS, Sanity, Netlify CMS, Airtable, Notion, and Google Sheets, but ultimately the fact Strapi can use Postgres as a datastore is what sold it. This gives me infinite power of the data including from my via [SQLPro Studio](https://www.sqlprostudio.com).

With Strapi in place, I wrote a little Ruby (that needs to be refactored) to dump the records from specified API endpoints into datafiles. When the site builds, I reference these datafiles to build the collection views and dynamically generate content pages (like [about](https://andrewm.codes/about/)).

As for blog articles, they can be stored in Strapi as well, but I elected to just use [DEV](https://dev.to/andrewmcodes) as the primary source for articles, dumped to a datafile using the [DEV API](https://docs.dev.to/api/) and a little Ruby. When the site builds, Bridgetown uses that datafile to generate the posts.

Notes were one thing that I originally built into the site but I decided to pull them all out after discovering [Gistpad](https://marketplace.visualstudio.com/items?itemName=vsls-contrib.gistfs). I plan to do a more detailed post about my workflow with this incredible extension in the future but the simple version is I use Gistpad's wiki feature to easily author notes in VS Code that sync to a GitHub repo. When I'm on my phone, I use [GitJournal](https://gitjournal.io/) to by hooking it up to my repo.

## What's Next

There are a few more features I want to add that didn't stop me from shipping:

- Update some of my old posts to work better with the new layout
- WebMentions integration
- Dynamic social share images
- More automations via iPhone Shortcuts and GitHub Actions

## Takeaways

If I had to do it over again I would spend the time upfront to carefully choose the underlying data structure instead of jumping in head first. I consider myself to be a tool builder but an incredible amount of time was wasted by trying to lean solely on third-party services. Once I leaned back into my natrual tendency to build tools, I was able to solve most of my issues with a few lines of Ruby.

At the end of the day though, I'm thrilled with the way it's turned out on the front and backend. More importantly tweaking my site will no longer get in the way of publishing content.

[Check it out and leave me your feedback!](https://andrewm.codes)
