---
categories:
  - post
title: 'CI for Ruby on Rails: GitHub Actions'
date: '2020-01-14T16:58:44.100Z'
excerpt: >-
  CI for Ruby on Rails: GitHub Actions vs. CircleCI   This is part of a three
  part series wher...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--PuzHQhI4--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://thepracticaldev.s3.amazonaws.com/i/4sxzx12la83xlo6ves0i.jpg
comments_count: 2
positive_reactions_count: 64
tags:
  - ruby
  - rails
  - github
  - tutorial
dev_to_url: 'https://dev.to/codefund/ci-for-ruby-on-rails-github-actions-3mn1'
layout: post
---

# CI for Ruby on Rails: GitHub Actions vs. CircleCI

_This is part of a three part series where I will walk you through setting up your CI suite with GitHub Actions, CircleCI, and then comparing which you may want to use if you are setting up continuous integration for your Rails app._

## Part 1: GitHub Actions

### 1. Set the name for your action

{% raw %}```yml
name: Run Tests & Linters

````{% endraw %}

### 2. Set what events should trigger the action to run

{% raw %}```yml
name: Run Tests & Linters

on:
  pull_request:
    branches:
      - '*'
  push:
    branches:
      - master
```{% endraw %}

What this says is that this action will run anytime a pull_request is updated on any branch, and also on pushes to master.

### 3. Create your job, and choose what to run the action on

{% raw %}```yml
jobs:
  build:
    runs-on: ubuntu-latest
```{% endraw %}

This tells our action we want to run the action on Ubuntu, and use the latest version GitHub has available, which is Ubuntu 18.04.

### 4. Define services

For a typical Rails app, you are probably using Redis for caching a tools like Sidekiq, and you also probably have a database. Defining services in your action allows us to use additional containers to run these types of tools.

{% raw %}```yaml
services:
  postgres: # The name of the service
    image: postgres:11 # A docker image
    env: # Environment variables you want to use inside the service
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: postgres
    ports: ['5432:5432'] # The port that you can access the service on
    options: >- # Options for the service, in this case we want to make sure that the Postgres container passes a health check
      --health-cmd pg_isready
      --health-interval 10s
      --health-timeout 5s
      --health-retries 5
  redis: # The name of the service
    image: redis # A docker image
    ports: ['6379:6379'] # The ports that you can access the service on
    options: --entrypoint redis-server # Options for the service
```{% endraw %}

### 5. Setup dependencies and checkout the branch

Here is where it got tricky for me. If you search for using GitHub actions with Rails, you will probably see something like this:

{% raw %}```yml
- uses: actions/checkout@v1
- name: Setup Ruby
  uses: actions/setup-ruby@v1
  with:
    ruby-version: 2.6.x
- uses: borales/actions-yarn@v2.0.0
  with:
    cmd: install
```{% endraw %}

This particular example is from my friend [Chris Oliver](https://gorails.com/episodes/github-actions-continuous-integration-ruby-on-rails), who runs [Go Rails](https://gorails.com) (check it out!!).

This solution would have been great except:
- The latest Ruby version available from GitHub is Ruby 2.6.3
- The latest Node version available from GitHub is Node 12.13.1

At [CodeFund](https://codefund.io), we are using Ruby 2.6.5 (about to bump to 2.7) and Node 13.0.1. There are a few solutions that have been proposed for this problem, like installing the version of Ruby you want from source with [ruby build](https://github.com/clupprich/ruby-build-action) or using a tool like [nvm](https://github.com/dcodeIO/setup-node-nvm). These may work for you but they can be slow, and they wouldn't work for a problem I would later have. Instead, I wrote my own Docker image that had everything I needed already built in. Ruby 2.6.5, Node 13.0.1, additional packages you would need for Postgres, Chrome for system tests, Bundler 2.0.2, and my generic environment variables.

I am not going to explain all of the details here, and I know I could reduce the size a bit but here is the first iteration of that image:

{% raw %}```Dockerfile
FROM ruby:2.6.5

LABEL "name"="Locomotive"
LABEL "version"="0.0.1"

ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV BUNDLE_PATH='/bundle/vendor'
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=C.UTF-8
ENV PG_HOST='postgres'
ENV PG_PASSWORD='postgres'
ENV PG_USERNAME='postgres'
ENV RACK_ENV='test'
ENV RAILS_ENV='test'
ENV REDIS_CACHE_URL='redis://redis:6379/0'
ENV REDIS_QUEUE_URL='redis://redis:6379/0'

RUN  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
     curl -sL https://deb.nodesource.com/setup_13.x | bash - && \
     wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
     echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list && \
     apt-get update && \
     apt-get install -y google-chrome-stable && \
     echo "CHROME_BIN=/usr/bin/google-chrome" | tee -a /etc/environment && \
     wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
     echo 'deb http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list && \
     apt-get -yqq install libpq-dev && \
     apt-get install -qq -y google-chrome-stable yarn nodejs postgresql postgresql-contrib

RUN gem install bundler:2.0.2
```{% endraw %}

### 6. Use Docker container

{% raw %}```yml
container:
      image: andrewmcodes/locomotive:v0.0.1 # my image name
      env: # additional environment variables I want to have access to
        DEFAULT_HOST: app.codefund.io
```{% endraw %}

Note: If you do not set a container, all steps will run directly on the host specified, which if you remember is Ubuntu 18.04.

As of now, our action looks like:

{% raw %}```yml
name: Run Tests & Linters

on:
  pull_request:
    branches:
      - '*'
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:11
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: postgres
        ports: ['5432:5432']
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
      redis:
        image: redis
        ports: ['6379:6379']
        options: --entrypoint redis-server
    container:
      image: andrewmcodes/locomotive:v0.0.1
      env:
        DEFAULT_HOST: app.codefund.io
```{% endraw %}

### 7. Add steps

Now it is time to run commands inside of our container. We will start by checking out the code.

{% raw %}```yml
steps:
  - uses: actions/checkout@v2
```{% endraw %}

### 8. Caching

Thankfully, GitHub provides some examples for getting started with your tools of choice for caching dependencies. I recommend checking those out and the documentation.

[GitHub Actions Cache Examples](https://github.com/actions/cache/blob/master/examples.md)
[Cache Documentation](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/caching-dependencies-to-speed-up-workflows)

NOTE: Individual caches are limited to 400MB and a repository can have up to 2GB of caches. Once the 2GB limit is reached, older caches will be evicted based on when the cache was last accessed. Caches that are not accessed within the last week will also be evicted.

{% raw %}```yml
 - name: Get Yarn Cache
   id: yarn-cache
   run: echo "::set-output name=dir::$(yarn cache dir)"

 - name: Node Modules Cache
   id: node-modules-cache
   uses: actions/cache@v1
   with:
     path: ${{ steps.yarn-cache.outputs.dir }}
     key: ${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}
     restore-keys: |
       ${{ runner.os }}-yarn-

 - name: Gems Cache
   id: gem-cache
   uses: actions/cache@v1
   with:
     path: vendor/bundle
     key: ${{ runner.os }}-gem-${{ hashFiles('**/Gemfile.lock') }}
     restore-keys: |
       ${{ runner.os }}-gem-

 - name: Assets Cache
   id: assets-cache
   uses: actions/cache@v1
   with:
     path: public/packs-test
     key: ${{ runner.os }}-assets-${{ steps.extract_branch.outputs.branch }}
     restore-keys: |
       ${{ runner.os }}-assets-
```{% endraw %}

### 9. Bundle, Yarn, and Precompile Assets

Next, we will want to run Bundler and Yarn to install our dependencies if they were not restored from the cache, and precompile our assets.

{% raw %}```yml
 - name: Bundle Install
   run: bundle check || bundle install --path vendor/bundle --jobs 4 --retry 3

 - name: Yarn Install
   run: yarn check || bin/rails yarn:install

 - name: Compile Assets
   run: |
      if [[ ! -d public/packs-test ]]; then
        bin/rails webpacker:compile
      else
        echo "No need to compile assets."
      fi
```{% endraw %}

NOTE: You may be able to skip the asset compilation, that is up to you.

### 10. Update some files

In order to get this to work, I had to make a couple updates to some files in my project.

1. {% raw %}`config/database.yml`{% endraw %}
  Update host for test to be: {% raw %}`host: <%= ENV.fetch("PG_HOST", "localhost") %>`{% endraw %}
2. Update {% raw %}`test/application_system_test_case.rb`{% endraw %}
  {% raw %}```rb
     require "test_helper"

     class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
       driven_by :selenium, using: :headless_chrome, screen_size: [1400,1400] do |driver_options|
        driver_options.add_argument("--disable-dev-shm-usage")
        driver_options.add_argument("--no-sandbox")
      end
    end
  ```{% endraw %}

### 11. Setup Database

One last item we need to take care of prior to running the tests and linters is setting up our database.

{% raw %}```yml
- name: Setup DB
      run: bin/rails db:drop db:create db:structure:load --trace
```{% endraw %}

### 12. Run Tests and Linters

Now we can finally run our tests and linters.

{% raw %}```yml
- name: Run Rails Tests
  run: |
    bin/rails test
    bin/rails test:system

- name: Zeitwerk Check
  run: bundle exec rails zeitwerk:check

- name: StandardRB Check
  run: bundle exec standardrb --format progress

- name: ERB Lint
  run: bundle exec erblint app/views_redesigned/**/*.html.erb

- name: Prettier-Standard Check
  run: yarn run --ignore-engines prettier-standard --check 'app/**/*.js'
```{% endraw %}

At this point, your action should be complete!

Here is my completed action file:

{% raw %}```yml
name: Run Tests & Linters

on:
  pull_request:
    branches:
      - '*'
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:11
        env:
          POSTGRES_USER: postgres
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: postgres
        ports: ['5432:5432']
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
      redis:
        image: redis
        ports: ['6379:6379']
        options: --entrypoint redis-server
    container:
      image: andrewmcodes/locomotive:v0.0.1
      env:
        DEFAULT_HOST: app.codefund.io
    steps:
    - uses: actions/checkout@v1

    - name: Get Yarn Cache
      id: yarn-cache
      run: echo "::set-output name=dir::$(yarn cache dir)"

    - name: Cache Node Modules
      id: node-modules-cache
      uses: actions/cache@v1
      with:
        path: ${{ steps.yarn-cache.outputs.dir }}
        key: ${{ runner.os }}-yarn-${{ hashFiles('**/yarn.lock') }}
        restore-keys: |
          ${{ runner.os }}-yarn-

    - name: Cache Gems
      id: gem-cache
      uses: actions/cache@v1
      with:
        path: vendor/bundle
        key: ${{ runner.os }}-gem-${{ hashFiles('**/Gemfile.lock') }}
        restore-keys: |
          ${{ runner.os }}-gem-

    - name: Cache Assets
      id: assets-cache
      uses: actions/cache@v1
      with:
        path: public/packs-test
        key: ${{ runner.os }}-assets-${{ steps.extract_branch.outputs.branch }}
        restore-keys: |
          ${{ runner.os }}-assets-

    - name: Bundle Install
      run: bundle install --path vendor/bundle --jobs 4 --retry 3

    - name: Yarn Install
      run: bin/rails yarn:install

    - name: Compile Assets
      shell: bash
      run: |
        if [[ ! -d public/packs-test ]]; then
          bundle exec rails webpacker:compile
        else
          echo "No need to compile assets."
        fi

    - name: Setup DB
      run: bin/rails db:drop db:create db:structure:load --trace

    - name: Run Rails Tests
      run: |
        bin/rails test
        bin/rails test:system

    - name: Zeitwerk Check
      run: bundle exec rails zeitwerk:check

    - name: StandardRB Check
      run: bundle exec standardrb --format progress

    - name: ERB Lint
      run: bundle exec erblint app/views_redesigned/**/*.html.erb

    - name: Prettier-Standard Check
      run: yarn run --ignore-engines prettier-standard --check 'app/**/*.js'
```{% endraw %}

As you can see, setting up GitHub Actions for your CI can be quite involved and requires a lot of initial setup. Hopefully this post will help you if you are thinking of experimenting with them on your Rails app. Check back later this week for Part 2, setting up CircleCI!

*[This post is also available on DEV.](https://dev.to/codefund/ci-for-ruby-on-rails-github-actions-3mn1)*


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
