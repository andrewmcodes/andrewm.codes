---
title: Podcasts
layout: collections
permalink: /podcasts/
emoji: 🎙
---

## Host

{% rendercontent "list" %}
{% for podcast in site.data.podcasts %}
{% render "card/project", name: podcast.name, link: podcast.link %}
{% endfor %}
{% endrendercontent %}

## Interviews

{% rendercontent "list" %}
{% for podcast in site.data.interviews %}
{% render "card/project", name: podcast.title, link: podcast.link %}
{% endfor %}
{% endrendercontent %}
