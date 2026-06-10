---
title: How to Unhide Desktop Icons on macOS
description: "If your desktop icons disappear, you may need to toggle the desktop back on via the command line."
tags:
  - zsh
  - macos
  - alfred
date: 2021-06-05 11:22:38.000000000 -07:00
last_modified_at: 2022-02-08 02:18:47.187000000 Z
categories:
  - snippets
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

- [The Easiest Way To Hide Desktop Icons On Mac – Setapp](https://setapp.com/how-to/hide-icons-on-mac)
