---
title: Host
emoji: 🗣️
---
{% find hosted_shows where site.data.podcast_shows, role contains "host" %}
{% find former_hosted_shows where site.data.podcast_shows, role contains "former host" %}

<div class="content">
  <h2>Shows I Currently Host</h2>
</div>
{%- for hosted_shows in hosted_shows -%}
  {% render "_v2/list_item", url: hosted_shows.url, title: hosted_shows.name, external: true %}
{%- endfor -%}

<div class="content">
<hr />
  <h2>Shows I've Previously Hosted</h2>
</div>
{%- for former_hosted_shows in former_hosted_shows -%}
  {% render "_v2/list_item", url: former_hosted_shows.url, title: former_hosted_shows.name, external: true %}
{%- endfor -%}
