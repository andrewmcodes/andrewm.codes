---
title: Create Repository from Current Directory with the GitHub CLI
description: "Use gh to create a repo using your current directory as the source and push to GitHub"
tags:
  - gh
  - github
  - cli
categories: terminal
date: "2022-03-30T01:04:33-07:00"
last_modified_at: "2022-03-30T01:04:33-07:00"
---

```sh
gh repo create your-repo --public --source=. --push
```

## Usage

1. Make sure you have the GitHub CLI installed and you are signed in[^1]
2. Run the command above to create a public repo from the current directory and push

---

[^1]: [GitHub CLI Documentation](https://cli.github.com/)
