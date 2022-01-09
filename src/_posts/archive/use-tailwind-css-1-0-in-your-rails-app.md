---
series: null
featured: false
title: Use Tailwind CSS 1.1 in your Rails App
description: How to install Tailwind CSS 1.1 in a Ruby on Rails app.
urls:
  dev_to: 'https://dev.to/andrewmcodes/use-tailwind-css-1-0-in-your-rails-app-4pm4'
tags:
  - tailwind-css
  - rails
  - webpacker
categories: archived
date: '2019-04-07T03:07:25Z'
lastmod: '2022-01-09T13:41:12.670Z'
---

For the purpose of this tutorial, we will assume you have Ruby and the Rails gem installed. Please visit the [Getting Started with Rails Guide](https://guides.rubyonrails.org/getting_started.html) if you do not.

## Create a new Rails project

```sh
rails new rails_tailwind --skip-coffee --webpack -d postgresql
cd rails_tailwind
rails db:create
```

This will create a new Rails project for you with webpack and Postgres configured for you and create our databases. We will not use coffeescript, which is why we add the `--skip-coffee` flag. You can also omit the `-d postgresql` flag if you like, but if you want to deploy to something like Heroku, I would recommend adding it. If you keep the Postgres flag, make sure you have Postgres installed and it is running. You can install Postgres on macOS by running `brew install postgresql && brew services start postgresql`

## Running Rails and Webpack

You need to run the Rails server and webpack-dev-server in two terminal tabs/windows unless you use Docker or a gem like Foreman.

For now, we will just create two terminal windows. In one window, run:

```sh
rails s
```

and in the other:

```sh
./bin/webpack-dev-server
```

You should see rails welcome page if you navigate to `localhost:3000` in your browser.

![rails default information page](https://guides.rubyonrails.org/images/getting_started/rails_welcome.png)

## Generate a Home controller

In order to see the Tailwind styles that we will integrate later, we at minimum need a controller and view.

```sh
rails generate controller Home index
```

You can remove the generated JS, SCSS, and helper file, we won't be needing them.

```sh
rm app/helpers/home_helper.rb app/assets/javascripts/home.js app/assets/stylesheets/home.scss
```

## Configure your routes

Change your `config/routes.rb` file to:

```rb
# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#index'
  resources :home, only: :index
end
```

Restart your Rails server, and now you should see the following on `localhost:3000`

![home index](https://i.imgur.com/A47j9dx.png)

## Install Tailwind CSS

Run the following command in your terminal:

```sh
yarn add tailwindcss --dev
```

This should add the Tailwind package to your `package.json`.

To create a custom config file, you can run:

```sh
./node_modules/.bin/tailwind init
```

This should create a `tailwind.config.js` file at the root of your project. This file can be used to customize the Tailwind defaults. Read more [here](https://tailwindcss.com/docs/configuration)

Next, add the following two lines to `postcss.config.js`

```js
require('tailwindcss'),
require('autoprefixer'),
```

Your `postcss.config.js` file should now look like this:

```js
module.exports = {
  plugins: [
    require('autoprefixer'),
    require('postcss-import'),
    require('tailwindcss'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    })
  ]
}
```

## Configure Tailwind

_There are a few ways you can do this but this is my personal preference._

Remove the assets folder:

```sh
rm -rf app/assets
```

Rename the `app/javascript` directory to `app/frontend`:

```sh
mv app/javascript app/frontend
```

Tell webpacker to use this new folder by changing the source_path in `config/webpacker.yml` from: `source_path: app/javascript` to `source_path: app/frontend`.

Next, we need to setup our stylesheets:

```sh
touch app/frontend/packs/stylesheets.css
```

Paste the following into our new `stylesheets.css` file. _This is straight from the [tailwind docs](https://tailwindcss.com/docs/installation#step-2-add-tailwind-to-your-css)_

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

Add the following line in `app/frontend/packs/application.js`:

```js
import './stylesheets.css'
```

The last step is to tell Rails to use our packs. In `app/views/layouts/application.html.erb`, change:

```erb
<%%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
<%%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
```

to:

```erb
<%%= stylesheet_pack_tag 'stylesheets', 'data-turbolinks-track': 'reload' %>
<%%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
```

Restart the Rails server and webpack-dev-server and you should now see the following on `localhost:3000`

![tailwind home index](https://i.imgur.com/C64oFFy.png)

Tailwind should now be working so lets tweak our views to see some Tailwind goodness.

## Update views to use TailwindCSS

In `app/views/layouts/application.html.erb` change:

```erb
<body>
  <%%= yield %>
</body>
```

to:

```erb
<body class="min-h-screen bg-gray-100">
  <div class="container mx-auto">
    <%%= yield %>
  </div>
</body>
```

and in `app/views/home/index.html.erb` change:

```erb
<h1>Home#index</h1>
<p>Find me in app/views/home/index.html.erb</p>
```

to:

```erb
<section class="py-8 text-center">
  <h1 class="mb-2 text-5xl">Ruby on Rails + TailwindCSS</h1>
  <p class="mb-8 text-xl">❤️ A match made in heaven️️ ❤️</p>
  <a href="https://tailwindcss.com" class="px-8 py-4 font-bold text-white bg-teal-500 rounded hover:bg-teal-700" target="_blank">Tailwind Docs</a>
</section>
```

You should now see the following page when you navigate to `localhost:3000`

![updated tailwind home index](https://i.imgur.com/okfqCoS.png)

And now you have Tailwind CSS working in your Rails app!

If you are interested in using PurgeCSS to remove unused styles, I recommend checking out [GoRails Episode #294](https://gorails.com/episodes/purgecss?autoplay=1)

Happy coding!
