---
series: null
featured: false
title: How to Unhide Desktop Icons on macOS
description: 'If your desktop icons dissapear, you may need to toggle the desktop on via the command line.'
tags:
  - zsh
  - macos
  - alfred
category: snippet
date: '2021-06-05T11:22:38-07:00'
lastmod: '2022-01-22T02:24:40.322Z'
---

One day I realized all of the desktop icons on my 2019 MacBook Pro were missing, but still visible in Finder. I thought maybe it was a bug in Big Sur 11.4 but I eventually found the solution.

There is a command to hide the icons on the desktop:

```bash
defaults write com.apple.finder CreateDesktop FALSE; killall Finder
```

I don't remember running it, but by setting `CreateDesktop` to `TRUE` and restarting Finder, all my icons showed back up!

```bash
defaults write com.apple.finder CreateDesktop TRUE; killall Finder
```

To make this easier in the future, I added a function to my shell:

```bash
# Pass TRUE or FALSE - toggles desktop icons on and off.
function toggle_desktop_icons()
{
  if [ -z "$1" ]
  then
    echo "You must pass 'TRUE' or 'FALSE' to this function!"
    echo "Try 'toggle_desktop_icons true' or 'toggle_desktop_icons false'"
    echo ""
    echo "Aborting!"
    return 0
  fi

  defaults write com.apple.finder CreateDesktop $1; killall Finder
}
```

## References

- [The Easiest Way To Hide Desktop Icons On Mac – Setapp](https://setapp.com/how-to/hide-icons-on-mac){:target="_blank" rel="noopener"}
