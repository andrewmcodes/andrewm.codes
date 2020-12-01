---
title: categories
layout: md
permalink: /categories/
heading: categories
emoji: 🏷
---

<dl class="data-list">
  {% for category in site.categories %}
    {% render "data", title: category.first %}
  {% endfor %}
</dl>
