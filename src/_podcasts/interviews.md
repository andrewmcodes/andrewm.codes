---
title: Interviews
emoji: 👥
---
{% find interviews where site.data.podcast_episodes, role contains "interviewee" %}
{%- for interview in interviews -%}
  {% render "_v2/list_item", url: interview.url, title: interview.title, external: true %}
{%- endfor -%}
