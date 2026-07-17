---
title: Create Repository from Current Directory with the GitHub CLI
description: Use gh to create a repo using your current directory as the source and push to GitHub without having to set your upstream.
tags:
  - gh
  - github
  - cli
  - terminal
date: 2022-03-30 08:00:00.000000000 Z
last_modified_at: 2022-03-30 08:00:00.000000000 Z
---

<%= render(Command.new) { "gh repo create your-repo --public --source=. --push" } %>

## Usage

1. Make sure you have the GitHub CLI installed and you are signed in
2. Run the command above to create a public repo from the current directory and push

## Resources

- [GitHub CLI Documentation](https://cli.github.com/)
