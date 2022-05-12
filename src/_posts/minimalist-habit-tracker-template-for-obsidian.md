---
series: null
featured: false
title: Minimalist Habit Tracker Template for Obsidian
description: A short tutorial on how to build a minimalist habit tracker template for Obsidian using the Dataview plugin.
tags:
  - obsidian
  - dataview
  - template
categories: tutorial
date: "2022-05-12T02:25:58-07:00"
last_modified_at: "2022-05-12T02:26:03-07:00"
---

In [Obsidian](https://obsidian.md), there are usually many different ways to implement a feature that you would like to have in your vault. Habit tracking is a way to help you track and implement habits in your daily life.

## Daily Notes

If you are already creating daily notes in Obsidian, via the [Daily Notes core plugin](https://help.obsidian.md/Plugins/Daily+notes) or the [Periodic Notes community plugin](https://github.com/liamcain/obsidian-periodic-notes), it makes sense to track your habits here as well. In order to accomplish this, we can leverage the power of [Dataview](https://github.com/blacksmithgu/obsidian-dataview) and templates to create a minimal dashboard for tracking our habit's progress for the week.

Moving forward, I will assume you have [Periodic Notes](https://github.com/liamcain/obsidian-periodic-notes) or [Daily Notes](https://help.obsidian.md/Plugins/Daily+notes) plugin enabled and configured with a template. You do not have to use the [Templater community plugin](https://github.com/SilentVoid13/Templater), the [Templates core plugin](https://help.obsidian.md/Plugins/Templates) will work as well. I will be using Templater in the examples below, but you can sub out any of the special syntax for [Obsidian Templates](https://help.obsidian.md/Plugins/Templates) equivalent.

## Daily Note Template

Here is an example daily note template with Templater, which includes the habits we want to track:

```md
# [[<%% tp.file.title %>|<%% moment(tp.file.title).format("MMMM Do, YYYY") %>]]

[[<%% tp.date.yesterday("YYYY-MM-DD") %>]] | [[<%% tp.date.tomorrow("YYYY-MM-DD") %>]]

## Habits

**Reading**::
**Sleep**:: 0
**Exercise**:: 0
**Highlights**:: 0
**Mindfulness**:: 0

## Notes
```

We will use this template for our daily notes. Whenever we create a new daily note, we can fill in the values for our habits. An example of a daily note with the habits filled in:

<img alt="Obsidian Daily Note Template" src="<%= cloudinary_url 'v1652347823/posts/minimalist-habit-tracker-template-for-obsidian/daily-note-template_nj1yx5', :medium %>" />

## Dashboard

Now we can create a minimal dashboard to track our habits throughout the week. Make sure [Dataview](https://github.com/blacksmithgu/obsidian-dataview) is enabled and create a new note for your dashboard with the following:

```dataview
TABLE WITHOUT ID
  file.link as Date,
  choice(exercise > 30, "✅", "❌") as Exercise,
  choice(sleep > 6, "✅", "❌") as Sleep,
  choice(highlights >= 3, "✅", "❌") as Highlights,
  choice(mindfulness > 10, "✅", "❌") as Mindfulness,
  reading as Reading
FROM "daily"
WHERE file.day <= date(now) AND file.day >= date(now) - dur(7days)
SORT file.day ASC
```

Note that `FROM "daily"` determines which pages are collected and displayed. In this case, we are only collecting notes in the `daily` folder. You can select based on other sources like tags and links. Refer to the [Dataview FROM documentation](https://blacksmithgu.github.io/obsidian-dataview/query/queries/#from) for more information.

After we accumulate more daily notes, our dashboard will look something like:

<img alt="Obsidian Habit Tracker Dashboard" src="<%= cloudinary_url 'v1652347824/posts/minimalist-habit-tracker-template-for-obsidian/habit-tracker-dashboard_asfzri', :medium %>" />

## Conclusion

This is my preferred method for creating a habit tracking dashboard, but as I said in the beginning, there are multiple ways of accomplishing this behavior.

You can extend this pattern to create dashboards for other features, such as: mood tracking, reading list, journaling, etc.

Let me know what you come up with on [Twitter!](https://twitter.com/andrewmcodes)
