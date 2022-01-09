---
series: webpacker-6
featured: false
title: 'Webpacker 6: Tutorial Setup'
description: 'Before we start the upgrade process for Webpacker 6, we are going to create a small demo application...'
urls:
  dev_to: 'https://dev.to/andrewmcodes/webpacker-6-tutorial-setup-281k'
tags:
  - rails
  - ruby
  - tutorial
  - webpacker
categories: tutorial
date: '2020-12-23T22:00:26Z'
lastmod: '2022-01-09T13:40:16.636Z'
---

Before we start the upgrade process for Webpacker 6, we are going to create a small demo application for us to work on.

If you are upgrading an existing app or not using this series as a tutorial, you can skip this step! We will begin the formal upgrade process in the next article.

## Generate a new Rails app

First we will generate new Ruby on Rails app:

```sh
rails new webpacker_6 --skip-sprockets --skip-spring --skip-webpack-install --skip-bundle
cd webpacker_6
```

- `--skip-sprockets`: Skip Sprockets files
- `--skip-spring`: Don't install Spring application preloader
- `--skip-bundle`: Don't run bundle install
- `--skip-webpack-install`: Don't run Webpack install

### Setup the Database

```sh
bin/rails db:prepare
```

### Turn off asset scaffolding

Prevent Rails from creating asset files when running the generators and scaffolds:

```diff
# config/application.rb

# ...
module Webpacker6
  class Application < Rails::Application
    config.load_defaults 6.1
+    config.generators do |g|
+      g.assets false
+    end
  end
end
```

## Add Pages Controller

Generate pages controller with a home action:

```sh
bin/rails g controller pages home
```

## Add Root Route

Set `pages#home` as the root route:

```diff
# config/routes.rb

Rails.application.routes.draw do
  get 'pages/home'
+  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
```

> Note: Because we skipped the Webpacker install task, you will get an error if you try to start the application as is. We will fix that in the next article.
