---
series: null
featured: true
title: How to install Ruby on Rails 6.1 with asdf on macOS Big Sur
description: 'Ruby and Ruby on Rails have an outdated reputation of being difficult to set up, and some jump on thi...'
urls:
  dev_to: 'https://dev.to/andrewmcodes/how-to-install-ruby-on-rails-6-1-with-asdf-on-macos-big-sur-31c3'
tags:
  - ruby
  - rails
  - tutorial
  - beginners
categories: tutorial
date: '2021-02-25T00:38:27Z'
lastmod: '2022-01-22T07:59:44.454Z'
---

Ruby and Ruby on Rails have an outdated reputation of being difficult to set up, and some jump on this point to push their full stack JavaScript fantasies. In 2021, however, this doesn’t have to be an issue with the correct tool.

In this tutorial, we will set up Ruby on Rails 6.1 with Ruby 3, a PostgreSQL database, and Webpacker via Node on a clean install of macOS Big Sur without any pain thanks to [asdf](https://asdf-vm.com/#/).

## Step 1 - Install Homebrew

> The Missing Package Manager for macOS (or Linux)

Install [Homebrew](https://brew.sh/) and update your `$PATH`. Take a look at the [official documentation](https://docs.brew.sh/) if you run into issues.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.zshrc
source ~/.zshrc # If you see weird behavior, restart your terminal
brew doctor
```

If everything is set up correctly, `brew doctor` will return `Your system is ready to brew.`. Address issues if there are any as they may cause issues down the road. You may also want to set up [Homebrew's shell-completion](https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh) at this time.

## Step 2 - Install asdf

> Manage multiple runtime versions with a single CLI tool

Install [asdf](https://asdf-vm.com/) as well as some necessary dependencies and update your `~/.zshrc`. If you'd like to install asdf through a different method, check out [the official documentation](https://asdf-vm.com/#/core-manage-asdf).

We are also going to create a `.asdfrc` file and [enable `legacy_version_file`](https://asdf-vm.com/#/core-configuration?id=homeasdfrc), which will allow us to get version info from files like `.ruby-version`.

```bash
brew install coreutils curl git gpg gawk zsh yarn asdf
echo -e "\n. $(brew --prefix asdf)/asdf.sh" >> ~/.zshrc
echo 'legacy_version_file = yes' >> ~/.asdfrc
```

Restart your terminal.

## Step 3 - Install Ruby

```bash
asdf plugin add ruby
asdf install ruby 3.0.0
asdf global ruby 3.0.0
```

[Documentation](https://github.com/asdf-vm/asdf-ruby)

## Step 4 - Install Node

```bash
asdf plugin add nodejs
bash -c '`${ASDF_DATA_DIR:=$HOME/`.asdf}/plugins/nodejs/bin/import-release-team-keyring'
asdf install nodejs 14.16.0
asdf global nodejs 14.16.0
```

[Documentation](https://github.com/asdf-vm/asdf-nodejs)

## Step 5 - Install Postgres

```bash
asdf plugin add postgres
asdf install postgres 13.2
asdf global postgres 13.2
$HOME/.asdf/installs/postgres/13.2/bin/pg_ctl -D $HOME/.asdf/installs/postgres/13.2/data -l logfile start
```

[Documentation](https://github.com/smashedtoatoms/asdf-postgres)

🔥 You can [add this handy function to your `~/.zshrc`](https://gist.github.com/jbranchaud/3cda6be6e1dc69c6f55435a387018dac "3cda6be6e1dc69c6f55435a387018dac") from [Josh Branchaud](https://twitter.com/jbrancha) to make switching postgres versions easier.

## Step 6 - Create Ruby on Rails app

To make sure everything's correct, let's create a new Rails app with a postgres database:

```bash
gem install bundler rails
rails new asdf_demo -d postgresql
cd asdf_demo
bin/rails db:prepare
bin/rails s
```

Open `localhost:3000` in your browser and you should see the Rails welcome screen. 🥳

## Summary

In the end, this was all we needed to get a Rails app running on a clean install of macOS Big Sur:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.zshrc
source ~/.zshrc
brew doctor
brew install coreutils curl git gpg gawk zsh yarn asdf
echo -e "\n. $(brew --prefix asdf)/asdf.sh" >> ~/.zshrc
echo 'legacy_version_file = yes' >> ~/.asdfrc
# ⚠️ Restart your terminal ⚠️
asdf plugin add ruby
asdf install ruby 3.0.0
asdf global ruby 3.0.0
asdf plugin add nodejs
bash -c '`${ASDF_DATA_DIR:=$HOME/`.asdf}/plugins/nodejs/bin/import-release-team-keyring'
asdf install nodejs 14.16.0
asdf global nodejs 14.16.0
asdf plugin add postgres
asdf install postgres 13.2
asdf global postgres 13.2
$HOME/.asdf/installs/postgres/13.2/bin/pg_ctl -D $HOME/.asdf/installs/postgres/13.2/data -l logfile start
# ⚠️ Restart your terminal ⚠️
gem install bundler rails
rails new asdf_demo -d postgresql
cd asdf_demo
bin/rails db:prepare
bin/rails s
```

> I am sure there are ways to improve this and I would love to hear any optimizations you come up with!

It doesn't have to end here though! Checkout [asdf's plugin list](https://asdf-vm.com/#/plugins-all?id=plugin-list) for all available plugins. [Redis](https://github.com/smashedtoatoms/asdf-redis), [Elasticsearch](https://github.com/asdf-community/asdf-elasticsearch), and [ImageMagick](https://github.com/mangalakader/asdf-imagemagick) can all be managed through asdf.

Hopefully this tutorial will help you get up and running with a Ruby on Rails 6.1 development environment lightning fast and pain free. 🚀

Happy coding!
