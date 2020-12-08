---
title: Subscribed
emoji: 🔔
---
{% find podcasts where site.data.podcast_shows, role contains "listener" %}
{%- for podcast in podcasts -%}
  {% render "_v2/list_item", url: podcast.link, title: podcast.name, external: true %}
{%- endfor -%}
