---
categories:
  - post
title: How to set up Ruby on Rails 6 and TailwindCSS 1.1.4
date: '2020-01-26T07:12:44.021Z'
excerpt: >-
  Tutorial   For the purpose of this tutorial, we will assume you have Ruby and
  the Rails gem...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--rdvNpiaz--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://thepracticaldev.s3.amazonaws.com/i/i1zkcgdupe41vbluwd1d.jpg
comments_count: 5
positive_reactions_count: 56
tags:
  - ruby
  - rails
  - tutorial
  - beginners
dev_to_url: 'https://dev.to/andrewmcodes/ruby-on-rails-and-tailwindcss-1-1-4-mm5'
layout: post
---

# Tutorial

For the purpose of this tutorial, we will assume you have Ruby and the Rails gem installed. Please visit the [Getting Started with Rails Guide](https://guides.rubyonrails.org/getting_started.html) if you do not.

I will also be working through the creation of code in [this repo](https://github.com/andrewmcodes/tailwind_css_1_1_4_rails_demo). Please use the repo as a resource to help you in case you get stuck or open issues if it's broken!!

I created this demo using the following:

- Ruby 2.7
- Node 13.7.0
- Rails 6.0.2.1
- Webpacker 4.2.2
- TailwindCSS 1.1.4
- psql (PostgreSQL) 12.1

## Create a new Rails project

{% raw %}```sh
rails new tailwind_css_rails_demo -d postgresql
cd tailwind_css_rails_demo
rails db:create

````{% endraw %}

This will create a new Ruby on Rails project with PostgreSQL configured for you. You can omit the {% raw %}`-d postgresql`{% endraw %} flag if you would prefer to use SQLite or MySQL.

## Running Rails and Webpack

I prefer to run the Rails server in one command line tab and webpack-dev-server in another since it's much faster. In development, Rails can tell whether the webpack-dev-server has compiled your packs and will compile them inline if it has not been done.

Let's go ahead and get the app running:

{% raw %}```sh
# Terminal tab 1
rails s
```{% endraw %}

And webpack-dev-server:

{% raw %}```sh
# Terminal tab 2
./bin/webpack-dev-server
```{% endraw %}

You should now see Rails welcome page if you navigate to {% raw %}`localhost:3000`{% endraw %} in your browser.

![Rails default information page](https://guides.rubyonrails.org/images/getting_started/rails_welcome.png)

## Generate a new resource

I personally like to see more than one record in the database for tutorials to make the app seem more "real". You can skip this part if you are not interested in adding some seed data, and would rather create a Home controller or something similar like [in the previous tutorial](https://dev.to/andrewmcodes/use-tailwind-css-1-0-in-your-rails-app-4pm4).

If you would like some records in your database, lets scaffold out a small resource:

{% raw %}```sh
rails generate scaffold Post title:string content:text
```{% endraw %}

Rails will then generate several files for us, but we will only focus on a few.

Use the following command to run the generated migration:

{% raw %}```sh
rails db:migrate
```{% endraw %}

Now, lets add some seed data. Open {% raw %}`db/seeds.rb`{% endraw %} and add the following:

{% raw %}```ruby
# db/seeds.rb

10.times do |n|
  Post.create!(title:  "Post title - ## {n}", content: "This is the content for the # {n.ordinalize} post.")
end
```{% endraw %}

It's not important for this tutorial for you to fully grok that code, but I would be happy to explain it in more detail if you reach out or let me know in the comments. The TL;DR is that we now have 10 unique Post records in our database.

The last thing we need to do before getting to the fun part is to update our {% raw %}`config/routes.rb`{% endraw %} file to make the root path for the app the index page for posts.

{% raw %}```ruby
# config/routes.rb

Rails.application.routes.draw do
  resources :posts
  root to: "posts# index"
end
```{% endraw %}

Restart the Rails server, navigate to {% raw %}`localhost:3000`{% endraw %}, and you should see a table with our random data, with links to other CRUD actions.

## Install TailwindCSS

Now to the fun stuff.

Run the following command in your terminal to install TailwindCSS

{% raw %}```sh
yarn add tailwindcss
```{% endraw %}

Let's also add the Tailwind config file:

{% raw %}```sh
./node_modules/.bin/tailwind init
```{% endraw %}

This should create a {% raw %}`tailwind.config.js`{% endraw %} file at the root of your project. This file can be used to customize the TailwindCSS defaults, add plugins, and more. You can learn more about this from [Tailwind's docs](https://tailwindcss.com/docs/configuration)

We also need to update our PostCSS config that comes default with Rails 6 with two new requires:

{% raw %}```js
require('tailwindcss'),
require('autoprefixer'),
```{% endraw %}

I have been told the best order for these requires is as I have them below, but I think just adding them to the top of your PostCSS config will work for the majority of people:

{% raw %}```js
// postcss.config.js

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

Remove the assets folder, we won't be needing it since we will rely fully on Webpacker:

{% raw %}```sh
rm -rf app/assets
```{% endraw %}

Create a new stylesheet file:

{% raw %}```sh
touch app/javascript/src/application.scss
```{% endraw %}

Since we are using {% raw %}`postcss-import`{% endraw %} and Webpack, the [Tailwind docs](https://tailwindcss.com/docs/installation/) instruct us to add the following to our stylesheet file:

{% raw %}```scss
// app/javascript/src/application.scss

@import "tailwindcss/base";
@import "tailwindcss/components";
@import "tailwindcss/utilities";
```{% endraw %}

We also need to add following line in {% raw %}`app/javascript/packs/application.js`{% endraw %}:

{% raw %}```js
import '../src/application.scss'
```{% endraw %}

The last step is to tell Rails to use our pack files. In {% raw %}`app/views/layouts/application.html.erb`{% endraw %}, change:

{% raw %}```erb
<%= stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload' %>
<%= javascript_include_tag 'application', 'data-turbolinks-track': 'reload' %>
```{% endraw %}

to:

{% raw %}```erb
<%= stylesheet_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
<%= javascript_pack_tag 'application', 'data-turbolinks-track': 'reload' %>
```{% endraw %}

Restart the Rails server and webpack-dev-server and you should now see the following on {% raw %}`localhost:3000`{% endraw %}:

![tailwind home index](https://i.imgur.com/AaxxvBk.jpg)

Tailwind should now be working so lets tweak our views to see some Tailwind goodness.

## Update views to use TailwindCSS

In {% raw %}`app/views/layouts/application.html.erb`{% endraw %} change:

{% raw %}```html
<body>
  <%= yield %>
</body>
```{% endraw %}

to:

{% raw %}```html
<body class="min-h-screen bg-gray-100">
  <div class="container mx-auto">
    <%= yield %>
  </div>
</body>
```{% endraw %}

and in {% raw %}`app/views/posts/index.html.erb`{% endraw %} lets replace the scaffolded page with the following:

{% raw %}```html
<p id="notice"><%= notice %></p>
<h1 class="font-semibold text-4xl text-gray-700 my-8">Posts</h1>
<div class="w-full xl:w-8/12 mb-12 xl:mb-0 px-4">
  <div class="relative flex flex-col min-w-0 break-words bg-white w-full mb-6 shadow-lg rounded">
    <table class="items-center w-full bg-transparent border-collapse">
      <thead>
        <tr>
          <th class="px-6 bg-gray-100 text-gray-600 align-middle border border-solid border-gray-200 py-3 text-xs uppercase border-l-0 border-r-0 whitespace-no-wrap font-semibold text-left">Title</th>
          <th class="px-6 bg-gray-100 text-gray-600 align-middle border border-solid border-gray-200 py-3 text-xs uppercase border-l-0 border-r-0 whitespace-no-wrap font-semibold text-left">Content</th>
          <th class="px-6 bg-gray-100 text-gray-600 align-middle border border-solid border-gray-200 py-3 text-xs uppercase border-l-0 border-r-0 whitespace-no-wrap font-semibold text-left", colspan="3"></th>
        </tr>
      </thead>
      <tbody>
        <% @posts.each do |post| %>
          <tr>
            <td class="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-no-wrap p-4 text-left"><%= post.title %></td>
            <td class="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-no-wrap p-4 text-left"><%= post.content %></td>
            <td class="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-no-wrap p-4 text-left"><%= link_to 'Show', post %></td>
            <td class="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-no-wrap p-4 text-left"><%= link_to 'Edit', edit_post_path(post) %></td>
            <td class="border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-no-wrap p-4 text-left"><%= link_to 'Destroy', post, method: :delete, data: { confirm: 'Are you sure?' } %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
  </div>
</div>
<%= link_to 'New Post', new_post_path %>
```{% endraw %}

You should now see the following page when you navigate to {% raw %}`localhost:3000`{% endraw %}

![updated tailwind home index](https://i.imgur.com/aiOlHht.jpg)

## Abstraction

This table looks so much better, but the classes for these elements are long and repetitive. Let's clean that up a bit by abstracting them to our scss file.

Create two new classes in {% raw %}`app/javascript/src/application.scss`{% endraw %}:

{% raw %}```scss
.table-header {
  @apply px-6 bg-gray-100 text-gray-900 align-middle border border-solid border-gray-200 py-3 text-xs uppercase border-l-0 border-r-0 whitespace-no-wrap font-semibold text-left;
}

.table-content {
  @apply border-t-0 px-6 align-middle border-l-0 border-r-0 text-xs whitespace-no-wrap p-4 text-left;
}
```{% endraw %}

Then in our HTML, change all of the table head and body element classes accordingly. We also darkened the header text to make the change standout.

When you reload the page, you should see the same screen as before, only with darker table headings.

## Summary

Hopefully this is helpful to those of you looking to add TailwindCSS to your Rails app.

If you are interested in more information about this article of using Rails and TailwindCSS, leave a comment or reach out to me on Twitter and I am happy to chat.

[View repo for this post](https://github.com/andrewmcodes/tailwind_css_1_1_4_rails_demo)

Happy coding! 😄


*[This post is also available on DEV.](https://dev.to/andrewmcodes/ruby-on-rails-and-tailwindcss-1-1-4-mm5)*


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
