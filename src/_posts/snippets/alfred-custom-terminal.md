---
title: Alfred Custom Terminal Snippet
description: Integrate a custom terminal with Alfred's terminal integration.
tags:
  - warp
  - macos
  - archipelago
  - alfred
date: 2022-01-14 06:49:07.800000000 Z
last_modified_at: 2022-02-08 02:18:35.929000000 Z
---

```applescript
on alfred_script(q)
  do shell script "open -a Warp ~" -- [tl! highlight]
  set appOpen to false
  set nbrOfTry to 0
  delay 0.5
  repeat
    try
      tell application "System Events"
        if exists (window 1 of process "Warp") then
          set appOpen to true
          exit repeat
        end if
      end tell
    end try
    set nbrOfTry to nbrOfTry + 1
    if nbrOfTry = 20 then exit repeat
    delay 0.5
  end repeat
  if appOpen then tell application "System Events" to keystroke q & return
end alfred_script
```

## Usage

1. Replace `Warp` in the script above with the name of your terminal app, e.g., Archipelago, Fig, Warp
2. Open Alfred's preferences and navigate to the Terminal preferences under "Features"
3. Set `Application` to `Custom`
4. In the text box that appears, paste the script

## Resources

- [Accessing Alfred Preferences Documentation](https://www.alfredapp.com/help/kb/access-preferences/)
- [Alfred Terminal Documentation](https://www.alfredapp.com/help/features/terminal/)
