---
title: Tags
layout: md
permalink: /tags/
heading: Tags
emoji: 🏷
---

<dl class="data-list">
  {% for tag in site.tags %}
    {% render "data", title: tag.first %}
  {% endfor %}
</dl>
