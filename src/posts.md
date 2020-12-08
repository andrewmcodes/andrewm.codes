---
layout: collections
title: Posts
description: A collection of my blog posts.
emoji: ✍️
permalink: /posts/
---
  <div class="flex-wrap lg:flex md:flex sm:flex xl:justify-around md:justify-around sm:justify-around lg:justify-around">
{% for post in site.posts %}
{% render "article", post: post, authors: site.data.authors %}
{% endfor %}
</div>
