---
categories:
  - posts
title: Ruby on Rails Development with VS Code
date: '2020-01-16T04:38:37.842Z'
excerpt: >-
  I tried several editors when I first got into programming, but VS Code quickly
  stuck. For the past th...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--iDSa_uSZ--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://thepracticaldev.s3.amazonaws.com/i/oz1ryybc49yjadzqijwy.png
comments_count: 4
positive_reactions_count: 100
tags:
  - vscode
  - ruby
  - rails
  - productivity
dev_to_url: 'https://dev.to/andrewmcodes/ruby-on-rails-development-with-vs-code-p1i'
layout: post
---

I tried several editors when I first got into programming, but VS Code quickly stuck. For the past three years, I have been continually updating my VS Code settings, extensions, keybindings, and snippets to help me be as productive as my diehard VIM friends.

Here is a quick article showing my setup for working with Rails that I use when I work on [CodeFund](https://codefund.io) and my Rails side projects.

# Extensions

These are the ones I think are the most important. For a full list, check out [this gist](https://gist.github.com/andrewmcodes/8a173595a3dae44c3d6d39e977899eed).

## Theme

- [One Dark Pro](https://marketplace.visualstudio.com/items?itemName=zhuangtongfa.Material-theme)

## Icons

- [VSCode Great Icons](https://marketplace.visualstudio.com/items?itemName=emmanuelbeziat.vscode-great-icons)

## General

- [Auto Close Tag](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-close-tag)
- [Auto Rename Tag](https://marketplace.visualstudio.com/items?itemName=formulahendry.auto-rename-tag)
- [Bookmarks](https://marketplace.visualstudio.com/items?itemName=alefragnani.Bookmarks)
- [Bracket Pair Colorizer](https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer)
- [change-case](https://marketplace.visualstudio.com/items?itemName=wmaurer.change-case)
- [Code Runner](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)
- [Dash](https://marketplace.visualstudio.com/items?itemName=deerawan.vscode-dash)
- [Docker](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
- [Duplicate action](https://marketplace.visualstudio.com/items?itemName=mrmlnc.vscode-duplicate)
- [Font Awesome Auto-complete & Preview](https://marketplace.visualstudio.com/items?itemName=Janne252.fontawesome-autocomplete)
- [Git Extension Pack](https://marketplace.visualstudio.com/items?itemName=donjayamanne.git-extension-pack)
- [Git History](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory)
- [GitHub Pull Requests](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-pull-request-github)
- [gitignore](https://marketplace.visualstudio.com/items?itemName=codezombiech.gitignore)
- [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
- [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one)
- [Mustache](https://marketplace.visualstudio.com/items?itemName=dawhite.mustache)
- [Open in GitHub, Bitbucket, Gitlab, VisualStudio.com !](https://marketplace.visualstudio.com/items?itemName=ziyasal.vscode-open-in-github)
- [Peacock](https://marketplace.visualstudio.com/items?itemName=johnpapa.vscode-peacock)
- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [Prettier-Standard](https://marketplace.visualstudio.com/items?itemName=numso.prettier-standard-vscode)
- [Project Manager](https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager)
- [Quick and Simple Text Selection](https://marketplace.visualstudio.com/items?itemName=dbankier.vscode-quick-select)
- [Sass Lint](https://marketplace.visualstudio.com/items?itemName=glen-84.sass-lint)
- [Settings Sync](https://marketplace.visualstudio.com/items?itemName=Shan.code-settings-sync)
- [SVG Viewer](https://marketplace.visualstudio.com/items?itemName=cssho.vscode-svgviewer)
- [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml)

## Ruby & Rails

- [endwise\*](https://marketplace.visualstudio.com/items?itemName=kaiwood.endwise)
- [ERB Formatter/Beautify](https://marketplace.visualstudio.com/items?itemName=aliariff.vscode-erb-beautify)
- [Gem Lens](https://marketplace.visualstudio.com/items?itemName=ninoseki.vscode-gem-lens)
- [Rails Fast Nav\*](https://marketplace.visualstudio.com/items?itemName=jemmyw.rails-fast-nav)
- [Rails Flip-Flop\*](https://marketplace.visualstudio.com/items?itemName=bweave.rails-flip-flop)
- [Rails Routes](https://marketplace.visualstudio.com/items?itemName=aki77.rails-routes)
- [rails-latest-migration\*](https://marketplace.visualstudio.com/items?itemName=tmikoss.rails-latest-migration)
- [Rails](https://marketplace.visualstudio.com/items?itemName=bung87.rails)
- [Ruby Haml](https://marketplace.visualstudio.com/items?itemName=vayan.haml)
- [Ruby Solargraph\*](https://marketplace.visualstudio.com/items?itemName=castwide.solargraph)
- [Ruby\*](https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby)
- [Simple Ruby ERB](https://marketplace.visualstudio.com/items?itemName=vortizhe.simple-ruby-erb)
- [VSCode Ruby\*](https://marketplace.visualstudio.com/items?itemName=wingrunr21.vscode-ruby)
- [vscode-gemfile](https://marketplace.visualstudio.com/items?itemName=bung87.vscode-gemfile)
- [YARD Documenter](https://marketplace.visualstudio.com/items?itemName=pavlitsky.yard)

_\* must have!_

# Settings

These are my global settings. For a lot of projects, I will override these settings with a workspace settings file which works great.

{% raw %}```json
{
// TELEMETRY
// Enable usage data and errors to be sent to a Microsoft online service.
"telemetry.enableTelemetry": false,

    // WINDOW
    // Adjust the zoom level of the window.
    "window.zoomLevel": 0,

    // BREADCRUMBS
    // Enable/disable navigation breadcrumbs.
    "breadcrumbs.enabled": true,

    // EXPLORER
    // Controls whether the explorer should ask for confirmation to move files and folders via drag and drop.
    "explorer.confirmDragAndDrop": false,
    // Controls whether a top border is drawn on modified (dirty) editor tabs or not.
    "workbench.editor.highlightModifiedTabs": true,
    // Controls the location of the sidebar. It can either show on the left or right of the workbench.
    "workbench.sideBar.location": "right",
    // Controls which editor is shown at startup, if none are restored from the previous session.
    "workbench.startupEditor": "newUntitledFile",
    // Specifies the icon theme used in the workbench or 'null' to not show any file icons.
    "workbench.iconTheme": "vscode-great-icons",
    // Specifies the color theme used in the workbench.
    "workbench.colorTheme": "One Dark Pro",
    // Overrides colors from the currently selected color theme.
    "workbench.colorCustomizations": {
      "editor.background": "# 1a1c20",
      "editorIndentGuide.activeBackground": "# b83957",
      "tab.activeBorderTop": "# 64676E"
    },

    // EDITOR
    // Controls whether the editor should run in a mode where it is optimized for screen readers.
    "editor.accessibilitySupport": "off",
    // Controls the font family.
    "editor.fontFamily": "Fira Code",
    // Enables/Disables font ligatures.
    "editor.fontLigatures": true,
    // Controls the font size in pixels.
    "editor.fontSize": 14,
    // Controls the line height. Use 0 to compute the line height from the font size.
    "editor.lineHeight": 20,
    // Controls the letter spacing in pixels.
    "editor.letterSpacing": 0.2,
    // Controls the font weight.
    "editor.fontWeight": "400",
    // The number of spaces a tab is equal to.
    "editor.tabSize": 2,
    // Controls how the editor should render whitespace characters.
    "editor.renderWhitespace": "all",
    // Controls the cursor style.
    "editor.cursorStyle": "line",
    // Controls the width of the cursor when # editor.cursorStyle# is set to line.
    "editor.cursorWidth": 5,
    // Control the cursor animation style.
    "editor.cursorBlinking": "solid",
    // Render vertical rulers after a certain number of monospace characters. Use multiple values for multiple rulers.
    "editor.rulers": [
      120
    ],
    // Controls whether the minimap is shown.
    "editor.minimap.enabled": false,
    // Format a file on save.
    "editor.formatOnSave": false,
    // Timeout in milliseconds after which the formatting that is run on file save is cancelled.
    "editor.formatOnSaveTimeout": 1500,
    // Controls whether the editor should automatically format the pasted content.
    "editor.formatOnPaste": true,
    // Controls whether the editor should automatically format the line after typing.
    "editor.formatOnType": false,
    // Controls whether the editor should automatically adjust the indentation when users type, paste or move lines.
    "editor.autoIndent": "keep",

    // TERMINAL
    // Customizes which terminal application to run on macOS.
    "terminal.external.osxExec": "Archipelago.app",
    // The path of the shell that the terminal uses on macOS
    "terminal.integrated.shell.osx": "/bin/zsh",
    // Controls the font size in pixels of the terminal.
    "terminal.integrated.fontSize": 14,

    // FILES
    // When enabled, will trim trailing whitespace when saving a file.
    "files.trimTrailingWhitespace": true,
    // When enabled, insert a final new line at the end of the file when saving it.
    "files.insertFinalNewline": true,
    // When enabled, will trim all new lines after the final new line at the end of the file when saving it.
    "files.trimFinalNewlines": true,
    // Controls auto save of dirty files.
    "files.autoSave": "onFocusChange",
    // Configure file associations to languages (e.g. "*.extension": "html"). These have precedence over the default associations of the languages installed.
    "files.associations": {
      "*.erb": "erb",
      "Gemfile": "ruby"
    },

    // EMMET
    // Enable Emmet abbreviations in languages that are not supported by default.
    "emmet.includeLanguages": {
      "html": "html",
      "html.erb": "html",
      "html.inky": "html",
      "erb": "html"
    },

    // LANG: Javascript
    // Enable/disable automatic updating of import paths when you rename or move a file in VS Code.
    "javascript.updateImportsOnFileMove.enabled": "always",
    "npm.packageManager": "yarn",

    // PLUGIN: Ruby
    // Use built-in language server
    "ruby.useLanguageServer": true,
    // Time (ms) to wait after keypress before running enabled linters.
    "ruby.lintDebounceTime": 1500,
    //run non-lint commands with bundle exec
    "ruby.useBundler": true,
    // Set individual ruby linters to use
    "ruby.lint": {
      // enable standard via bundler
      "standard": {
        // Prefix the `{% endraw %}standard{% raw %}` command with `{% endraw %}bundle exec{% raw %}`
        "useBundler": true
      }
    },
    // Which system to use for formatting. Use `{% endraw %}false{% raw %}` to disable or if another extension provides this feature.
    "ruby.format": "standard",

    // GIT
    // When enabled, commits will automatically be fetched from the default remote of the current Git repository.
    "git.autofetch": true,
    // Commit all changes when there are no staged changes.
    "git.enableSmartCommit": true,
    // Enables commit signing with GPG.
    "git.enableCommitSigning": true,
    // Ignores the warning when there are too many changes in a repository.
    "git.ignoreLimitWarning": true,

    // PLUGIN: Gitlens
    // Specifies where to show the Repositories view
    "gitlens.views.repositories.location": "gitlens",
    // Specifies where to show the File History view
    "gitlens.views.fileHistory.location": "gitlens",
    // Specifies where to show the Line History view
    "gitlens.views.lineHistory.location": "gitlens",
    // Specifies where to show the Compare view
    "gitlens.views.compare.location": "gitlens",
    // Specifies where to show the Search Commits view
    "gitlens.views.search.location": "gitlens",
    // Specifies whether to provide an authors code lens, showing number of authors of the file or code block and the most prominent author (if there is more than one)
    "gitlens.codeLens.authors.enabled": false,
    // Specifies whether to provide a recent change code lens, showing the author and date of the most recent commit for the file or code block
    "gitlens.codeLens.recentChange.enabled": false,
    // Specifies whether to provide any Git code lens, by default.
    "gitlens.codeLens.enabled": false,

    // PLUGIN: Settings Sync
    // Controls whether opened editors should show in tabs or not.
    "sync.gist": "YOUR_TOKEN",

    // PLUGIN: Font Awesome Auto-complete
    "fontAwesomeAutocomplete.patterns": [
      "**/*.html",
      "**/*.html.erb"
    ],

    // PLUGIN: Peacock
    // Colors for Peacock extension
    "peacock.favoriteColors": [
      {
        "name": "Angular Red",
        "value": "# b52e31"
      },
      {
        "name": "Auth0 Orange",
        "value": "# eb5424"
      },
      {
        "name": "Azure Blue",
        "value": "# 007fff"
      },
      {
        "name": "C# Purple",
        "value": "# 68217A"
      },
      {
        "name": "Gatsby Purple",
        "value": "# 639"
      },
      {
        "name": "Go Cyan",
        "value": "# 5dc9e2"
      },
      {
        "name": "Java Blue-Gray",
        "value": "# 557c9b"
      },
      {
        "name": "JavaScript Yellow",
        "value": "# f9e64f"
      },
      {
        "name": "Mandalorian Blue",
        "value": "# 1857a4"
      },
      {
        "name": "Node Green",
        "value": "# 215732"
      },
      {
        "name": "React Blue",
        "value": "# 00b3e6"
      },
      {
        "name": "Something Different",
        "value": "# 832561"
      },
      {
        "name": "Vue Green",
        "value": "# 42b883"
      }
    ],

    // Language specific formatting settings
    "[jsonc]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[html]": {
      "editor.defaultFormatter": "vscode.html-language-features"
    },
    "[markdown]": {
      "editor.defaultFormatter": "yzhang.markdown-all-in-one"
    },
    "[yaml]": {
      "editor.defaultFormatter": "redhat.vscode-yaml"
    },
    "[json]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[typescript]": {
      "editor.defaultFormatter": "esbenp.prettier-vscode"
    },
    "[javascript]": {
      "editor.defaultFormatter": "numso.prettier-standard-vscode"
    },
    "[ruby]": {
      "editor.formatOnSave": true
    },
    "[scss]": {
      "editor.formatOnSave": true
    }

}

````{% endraw %}

# Keybindings

{% raw %}```json
[
  {
    "key": "shift+alt+e",
    "command": "erb.toggleTags",
    "when": "editorTextFocus"
  },
  {
    "key": "alt+f",
    "command": "extension.railsFlipFlop"
  }
]
```{% endraw %}

# Snippets

Checkout [hopsoft/model_probe](https://github.com/hopsoft/model_probe) if you are curious about the first snippet!

{% raw %}```json
{
  "model comments": {
    "prefix": "rmc",
    "body": [
      "  # extends ...................................................................",
      "",
      "  # includes ..................................................................",
      "",
      "  # relationships .............................................................",
      "",
      "  # validations ...............................................................",
      "",
      "  # callbacks .................................................................",
      "",
      "  # scopes ....................................................................",
      "",
      "  # additional config (i.e. accepts_nested_attribute_for etc...) ..............",
      "",
      "  # class methods .............................................................",
      "",
      "  # public instance methods ...................................................",
      "",
      "  # protected instance methods ................................................",
      "",
      "  # private instance methods ..................................................",
      ""
    ],
    "description": "model comments"
  },
  "Add pry binding": {
    "prefix": "bp",
    "body": [
      "binding.pry"
    ],
    "description": "Add pry binding"
  },
  "Add erb pry binding": {
    "prefix": "ebp",
    "body": [
      "<% binding.pry %>"
    ],
    "description": "Add erb pry binding"
  }
}
```{% endraw %}

Hopefully you can take something from my setup to add to yours!

Happy coding!

*[This post is also available on DEV.](https://dev.to/andrewmcodes/ruby-on-rails-development-with-vs-code-p1i)*


<script>
const parent = document.getElementsByTagName('head')[0];
const script = document.createElement('script');
script.type = 'text/javascript';
script.src = 'https://cdnjs.cloudflare.com/ajax/libs/iframe-resizer/4.1.1/iframeResizer.min.js';
script.charset = 'utf-8';
script.onload = function() {
    window.iFrameResize({}, '.liquidTag');
};
parent.appendChild(script);
</script>
````
