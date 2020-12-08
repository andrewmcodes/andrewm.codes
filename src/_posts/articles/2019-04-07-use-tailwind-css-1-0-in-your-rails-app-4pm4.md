---
title: Use Tailwind CSS 1.1 in your Rails App
date: '2019-04-07T22:39:38.998Z'
excerpt: >-
  NOTICE   This tutorial is out of date and may not work for you. I have written
  a new post ba...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--R8enoZcN--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://thepracticaldev.s3.amazonaws.com/i/3x0vy7vz4j7tk5s557m2.png
comments_count: 11
positive_reactions_count: 41
tags:
  - tailwind
  - tailwindcss
  - rails
  - tutorial
dev_to_url: 'https://dev.to/andrewmcodes/use-tailwind-css-1-0-in-your-rails-app-4pm4'
layout: post
categories:
  - posts
---

# NOTICE

This tutorial is out of date and may not work for you. I have written a new post based on my experience using Rails and TailwindCSS over the last few months that you can find [here](https://dev.to/andrewmcodes/ruby-on-rails-and-tailwindcss-1-1-4-mm5). Thanks for reading! 😄

# Tutorial

For the purpose of this tutorial, we will assume you have Ruby and the Rails gem installed. Please visit the [Getting Started with Rails Guide](https://guides.rubyonrails.org/getting_started.html) if you do not.

## Create a new Rails project

{% raw %}```sh
rails new rails_tailwind --skip-coffee --webpack -d postgresql
cd rails_tailwind
rails db:create

````{% endraw %}

This will create a new Rails project for you with webpack and Postgres configured for you and create our databases. We will not use coffeescript, which is why we add the {% raw %}`--skip-coffee`{% endraw %} flag. You can also omit the {% raw %}`-d postgresql`{% endraw %} flag if you like, but if you want to deploy to something like Heroku, I would recommend adding it. If you keep the Postgres flag, make sure you have Postgres installed and it is running. You can install Postgres on macOS by running {% raw %}`brew install postgresql && brew services start postgresql`{% endraw %}

## Running Rails and Webpack

You need to run the Rails server and webpack-dev-server in two terminal tabs/windows unless you use Docker or a gem like Foreman.

For now, we will just create two terminal windows. In one window, run:

{% raw %}```sh
rails s
```{% endraw %}

and in the other:

{% raw %}```sh
./bin/webpack-dev-server
```{% endraw %}

You should see rails welcome page if you navigate to {% raw %}`localhost:3000`{% endraw %} in your browser.

![rails default information page](https://guides.rubyonrails.org/images/getting_started/rails_welcome.png)

## Generate a Home controller

In order to see the Tailwind styles that we will integrate later, we at minimum need a controller and view.

{% raw %}```sh
rails generate controller Home index
```{% endraw %}

You can remove the generated JS, SCSS, and helper file, we won't be needing them.

{% raw %}```sh
rm app/helpers/home_helper.rb app/assets/javascripts/home.js app/assets/stylesheets/home.scss
```{% endraw %}

## Configure your routes

Change your {% raw %}`config/routes.rb`{% endraw %} file to:

{% raw %}```rb
# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home# index'
  resources :home, only: :index
end
```{% endraw %}

Restart your Rails server, and now you should see the following on {% raw %}`localhost:3000`{% endraw %}

![home index](https://i.imgur.com/A47j9dx.png)

## Install Tailwind CSS

Run the following command in your terminal:

{% raw %}```sh
yarn add tailwindcss --dev
```{% endraw %}

This should add the Tailwind package to your {% raw %}`package.json`{% endraw %}.

To create a custom config file, you can run:

{% raw %}```sh
./node_modules/.bin/tailwind init
```{% endraw %}

This should create a {% raw %}`tailwind.config.js`{% endraw %} file at the root of your project. This file can be used to customize the Tailwind defaults. Read more [here](https://tailwindcss.com/docs/configuration)

Next, add the following two lines to {% raw %}`postcss.config.js`{% endraw %}

{% raw %}```js
require('tailwindcss'),
require('autoprefixer'),
```{% endraw %}

Your {% raw %}`postcss.config.js`{% endraw %} file should now look like this:

{% raw %}```js
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
```{% endraw %}

## Configure Tailwind

_There are a few ways you can do this but this is my personal preference._

Remove the assets folder:

{% raw %}```sh
rm -rf app/assets
```{% endraw %}

Rename the {% raw %}`app/javascript`{% endraw %} directory to {% raw %}`app/frontend`{% endraw %}:

{% raw %}```sh
mv app/javascript app/frontend
```{% endraw %}

Tell webpacker to use this new folder by changing the source_path in {% raw %}`config/webpacker.yml`{% endraw %} from: {% raw %}`source_path: app/javascript`{% endraw %} to {% raw %}`source_path: app/frontend`{% endraw %}.

Next, we need to setup our stylesheets:

{% raw %}```sh
touch app/frontend/packs/stylesheets.css
```{% endraw %}

Paste the following into our new {% raw %}`stylesheets.css`{% endraw %} file. _This is straight from the [tailwind docs](https://tailwindcss.com/docs/installation# step-2-add-tailwind-to-your-css)_

{% raw %}```css
@tailwind base;

@tailwind components;

@tailwind utilities;
```{% endraw %}

Add the following line in {% raw %}`app/frontend/packs/application.js`{% endraw %}:

{% raw %}```js
import './stylesheets.css'
```{% endraw %}

The last step is to tell Rails to use our packs. In {% raw %}`app/views/layouts/application.html.erb`{% endraw %}, change:

{% raw %}```erb
<%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
```{% endraw %}

to:

{% raw %}```erb
<%= stylesheet_pack_tag 'stylesheets', 'data-turbolinks-track': 'reload' %>
<%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
```{% endraw %}

Restart the Rails server and webpack-dev-server and you should now see the following on {% raw %}`localhost:3000`{% endraw %}

![tailwind home index](https://i.imgur.com/C64oFFy.png)

Tailwind should now be working so lets tweak our views to see some Tailwind goodness.

## Update views to use TailwindCSS

In {% raw %}`app/views/layouts/application.html.erb`{% endraw %} change:

{% raw %}```erb
<body>
  <%= yield %>
</body>
```{% endraw %}

to:

{% raw %}```erb
<body class="min-h-screen bg-gray-100">
  <div class="container mx-auto">
    <%= yield %>
  </div>
</body>
```{% endraw %}

and in {% raw %}`app/views/home/index.html.erb`{% endraw %} change:

{% raw %}```erb
<h1>Home# index</h1>
<p>Find me in app/views/home/index.html.erb</p>
```{% endraw %}

to:

{% raw %}```erb
<section class="py-8 text-center">
  <h1 class="mb-2 text-5xl">Ruby on Rails + TailwindCSS</h1>
  <p class="mb-8 text-xl">❤️ A match made in heaven️️ ❤️</p>
  <a href="https://tailwindcss.com" class="px-8 py-4 font-bold text-white bg-teal-500 rounded hover:bg-teal-700" target="_blank">Tailwind Docs</a>
</section>
```{% endraw %}

You should now see the following page when you navigate to {% raw %}`localhost:3000`{% endraw %}

![updated tailwind home index](https://i.imgur.com/okfqCoS.png)

And now you have Tailwind CSS working in your Rails app!

If you are interested in using PurgeCSS to remove unused styles, I recommend checking out [GoRails Episode # 294](https://gorails.com/episodes/purgecss?autoplay=1)

Happy coding!


*[This post is also available on DEV.](https://dev.to/andrewmcodes/use-tailwind-css-1-0-in-your-rails-app-4pm4)*


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
