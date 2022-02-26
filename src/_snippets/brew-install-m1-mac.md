---
title: Install Brew on a M1 Mac
description: How to install Homebrew on macOS Monterey with a M1 chip.
tags:
  - install
  - macos
  - m1
categories: brew
date: "2022-02-26T02:02:01.852Z"
last_modified_at: "2022-02-26T02:24:21.213Z"
---

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

## Usage

1. Run `uname -m` in the Terminal of your choice and verify it outputs `arm64`[^1]
2. Run the command above[^2]
3. After the installation completes, run `brew doctor`
4. If the output of `brew doctor` is `Your system is ready to brew.`, you are done
5. If `brew doctor` returns issues, resolve them according to the provided instructions
6. You may want to set up Homebrew's shell-completion[^3] at this time

---

[^1]: If you are not using the M1 chip, [use this snippet instead](/snippets/brew-install-intel-mac/)
[^1]: [Homebrew Documentation](https://docs.brew.sh)
[^3]: [Homebrew Documentation: Configuring Completions in zsh](https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh)
