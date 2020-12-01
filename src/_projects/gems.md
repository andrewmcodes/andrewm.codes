---
title: 'Gems'
layout: collections
permalink: /projects/gems/
emoji: 💎
---

<dl class="data-list">
  {% for gem in site.data.gems %}
    {% render "data", link: gem.url, title: gem.name %}
  {% endfor %}
</dl>
