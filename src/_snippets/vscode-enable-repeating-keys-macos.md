---
title: Enable Repeating Keys in VS Code on macOS
description: "If you want to use Vim in VS Code, you have to enable repeating keys, which can be frustrating if you are new to Vim."
tags:
  - mac-defaults
  - macos
  - vim
categories: vs-code
date: "2022-02-27T07:37:44.751Z"
last_modified_at: "2022-02-27T07:37:49.678Z"
---

```sh
# VS Code
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false

# VS Code - Insiders
defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
```

## Usage

1. Run the first command above to enable repeating keys in VS Code
2. If you use VS Code Insiders[^1], run the second command as well
3. You may need to restart VS Code, but repeating keys should now be enabled

---

[^1]: [Visual Studio Code Insiders Documentation](https://code.visualstudio.com/insiders/)
