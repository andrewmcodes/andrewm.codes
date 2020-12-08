---
title: Tags
layout: md
emoji: 🏷
---

<dl class="data-list">
  {% for tag in site.tags %}
    {% render "data", title: tag.first %}
  {% endfor %}
</dl>
