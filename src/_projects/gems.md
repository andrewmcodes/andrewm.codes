---
title: Gems
emoji: 💎
---
{%- for gem in site.data.gems -%}
  {% rendercontent "_v2/list_item", url: gem.url, title: gem.name, external: true %}
    {% with icon %}
      {% svg images/icon/github.svg class="w-5 h-5 text-gray-400" %}
    {% endwith %}
  {% endrendercontent %}
{%- endfor -%}
