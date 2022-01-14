---
series: null
featured: false
title: Getting Started with Obsidian
description: "The beginners guide to using Obsidian, an advanced markdown note taking app."
tags:
  - obsidian
  - macos
  - notes
category: tutorial
date: "2022-01-14T04:46:23.056Z"
lastmod: "2022-01-14T06:40:45.822Z"
---

## Quick Start

TL;DR I built a [template vault](https://github.com/andrewmcodes/obsidian-beginner-vault-template) based on the settings and instructions in this post.

[Create your own vault from the template](https://github.com/andrewmcodes/obsidian-beginner-vault-template/generate) and then follow the instructions on the README to get started. Continue reading for the breakdown of what I think is a good default setup in Obsidian without any third-party plugins.

## Install

Obsidian can be installed on mobile for [iOS](https://apps.apple.com/us/app/obsidian-connected-notes/id1557175442) and [Android](https://play.google.com/store/apps/details?id=md.obsidian) and on desktop by [visiting their downloads page.](https://obsidian.md/download)

Alternatively, if you are on macOS you can use [Homebrew](https://brew.sh):

```bash
brew install --cask obsidian
```

## Startup

Once installed, opening Obsidian for the first time will land you on the [vault creator](https://help.obsidian.md/User+interface/Vault+switcher#Create+new+vaults) where you can create a new vault, open a folder in Obsidian as a vault, or open the [help vault where you can find the documentation.](https://help.obsidian.md/Obsidian/Index)

![Obsidian Splash Screen](https://res.cloudinary.com/andrewmcodes/image/upload/v1642138668/posts/getting-started-with-obsidian/20220113_182236_Obsidian_SplashScreen_tr5ytn.png)

Create a new vault and then enter in the name and choose a location.
![Obsidian Create New Vault](https://res.cloudinary.com/andrewmcodes/image/upload/v1642138668/posts/getting-started-with-obsidian/20220113_182436_Obsidian_NewVault_1_mukbs7.png)

When your vault opens for the first time, you may be prompted to [turn on Live Preview](https://help.obsidian.md/Live+preview+update) which I suggest doing.

![Live Preview Modal](https://res.cloudinary.com/andrewmcodes/image/upload/v1642138668/posts/getting-started-with-obsidian/20220113_182456_Obsidian_LivePreviewModal_qekx9c.png)

Your new vault should now be ready for notes to be added.

![Simple Obsidian Vault](https://res.cloudinary.com/andrewmcodes/image/upload/v1642138668/posts/getting-started-with-obsidian/20220114015141Z_Obsidian_simple-obsidian-vault-template_-_Obsidian_v0.13.19_snrawj.png)

## Setup

The first thing I do after creating a new Obsidian vault is to create the following folder structure:

```
.
├── _assets
│   ├── attachments
│   └── templates
└── daily
```

- `attachments` - this is where we will [store files](https://help.obsidian.md/How+to/Manage+attachments) like [images.](https://help.obsidian.md/How+to/Format+your+notes#Images)
- `templates` - This where we will store our [templates.](https://help.obsidian.md/Plugins/Templates)
- `daily` - This is where we will store our [daily notes.](https://help.obsidian.md/Plugins/Daily+notes)

## Settings

### Editor

| Setting          | Value   |
| ---------------- | ------- |
| Show frontmatter | Enabled |
| Fold heading     | Enabled |
| Fold indent      | Enabled |
| Use tabs         | Enabled |
| Tab size         | 2       |

### Files & Links

| Setting                              | Value                         |
| ------------------------------------ | ----------------------------- |
| Confirm file deletion                | Disabled                      |
| Automatically update internal links  | Enabled                       |
| Detect all file extensions           | Enabled                       |
| Default location for new attachments | In the folder specified below |
| Attachment folder path               | `_assets/attachments`         |

### Appearance

| Setting            | Value   |
| ------------------ | ------- |
| Translucent window | Enabled |
| Font size          | 15      |

### Hotkeys

I have modified some of the important hotkeys to better match VS Code's defaults since that is the text editor that I am most familiar with. Click the `Restore default` icon if you'd like to revert a specific hotkey to Obsidian's default hotkeys.

| Description                           | Shortcut    |
| ------------------------------------- | ----------- |
| Command palette: Open command palette | ⌘⇧P         |
| Delete current file                   | ⌘⇧Backspace |
| Delete paragraph                      | ⌘⇧D         |
| Edit file title                       | ⇧⌥T         |
| Focus on editor                       | ⌘1          |
| Quick switcher: Open quick switcher   | ⌘P          |
| Split horizontally                    | ⌘\          |
| Split vertically                      | ⌘⇧\         |
| Swap line down                        | ⇧⌥↑         |
| Swap line up                          | ⇧⌥↓         |

### Core plugins

| Plugin                                                                                 | Value    |
| -------------------------------------------------------------------------------------- | -------- |
| [Outgoing Links](https://help.obsidian.md/Plugins/Outgoing+links)                      | Enabled  |
| [Tag pane](https://help.obsidian.md/Plugins/Tag+pane)                                  | Enabled  |
| [Daily notes](https://help.obsidian.md/Plugins/Daily+notes)                            | Enabled  |
| [Templates](https://help.obsidian.md/Plugins/Templates)                                | Enabled  |
| Slash commands                                                                         | Enabled  |
| [Starred](https://help.obsidian.md/Plugins/Starred+notes)                              | Enabled  |
| [Markdown format importer](https://help.obsidian.md/Plugins/Markdown+format+converter) | Disabled |
| [Outline](https://help.obsidian.md/Plugins/Outline)                                    | Enabled  |
| [Audio recorder](https://help.obsidian.md/Plugins/Audio+recorder)                      | Enabled  |
| [Workspaces](https://help.obsidian.md/Plugins/Workspaces)                              | Enabled  |

### Community Plugins

| Setting   | Value    |
| --------- | -------- |
| Safe mode | Disabled |

## Core Plugin Options

### Templates

| Setting                  | Value               |
| ------------------------ | ------------------- |
| Template folder location | `_assets/templates` |

### Daily notes

#### Daily Note Template

Create a new template titled `t_daily` under `_assets/templates`. Refer to the [Templates documentation](https://help.obsidian.md/Plugins/Templates) for more information about variables.

```md
# {{date}}

## Notes

---

#daily
```

#### Settings

| Setting                    | Value                       |
| -------------------------- | --------------------------- |
| New file location          | daily                       |
| Template file location     | `_assets/templates/t_daily` |
| Open daily note on startup | Enabled                     |

#### Hotkeys

| Description                | Shortcut |
| -------------------------- | -------- |
| Templates: Insert template | ⌘⌥I      |
