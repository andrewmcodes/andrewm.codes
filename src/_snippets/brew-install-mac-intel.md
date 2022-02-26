---
title: Install Brew on a Mac Intel
description: How to install Homebrew on macOS Monterey with an Intel chip.
tags:
  - install
  - macos
  - intel
categories: brew
date: "2022-02-26T02:02:01.852Z"
last_modified_at: "2022-02-26T02:03:00.013Z"
---

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## Usage

1. Run the command above[^1] in your terminal application of choice
2. After the installation completes, run `brew doctor`
3. If the output of `brew doctor` is `Your system is ready to brew.`, you are done
4. If `brew doctor` returns issues, resolve them according to the provided instructions
5. You may want to set up Homebrew's shell-completion[^2] at this time

---

[^1]: [Homebrew Documentation](https://docs.brew.sh)
[^2]: [Homebrew Documentation: Configuring Completions in zsh](https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh)
