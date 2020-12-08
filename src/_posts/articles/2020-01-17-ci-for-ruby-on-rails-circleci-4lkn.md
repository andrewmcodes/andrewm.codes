---
categories:
  - posts
title: 'CI for Ruby on Rails: CircleCI'
date: '2020-01-17T19:50:24.862Z'
excerpt: >-
  CI for Ruby on Rails: GitHub Actions vs. CircleCI   This is part of a three
  part series wher...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--bmKbiFc4--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://thepracticaldev.s3.amazonaws.com/i/b4knmzfjstqjy1ph89dk.jpg
comments_count: 0
positive_reactions_count: 15
tags:
  - ruby
  - rails
  - tutorial
  - circleci
dev_to_url: 'https://dev.to/codefund/ci-for-ruby-on-rails-circleci-4lkn'
layout: post
---

# CI for Ruby on Rails: GitHub Actions vs. CircleCI

_This is part of a three part series where I will walk you through setting up your CI suite with GitHub Actions, CircleCI, and then comparing which you may want to use if you are setting up continuous integration for your Rails app._

## Part 2: CircleCI

### 1. Set the CircleCI version

{% raw %}```yml
version: 2.1

````{% endraw %}

### 2. Create your job(s), and choose a docker image to use.

CircleCI offers a lot of images for us to get started [here](https://hub.docker.com/r/circleci/ruby/tags/). Alternatively, you can use their [dockerfile-wizard](https://github.com/CircleCI-Public/dockerfile-wizard) to create your own custom image.

{% raw %}```yml
jobs:
  build:
    docker:
      - image: circleci/ruby:2.6.5-node-browsers
        environment:
          PG_HOST: localhost
          PG_USERNAME: ubuntu
          RAILS_ENV: test
          RACK_ENV: test
          DEFAULT_HOST: codefund.io
          PARALLEL_WORKERS: "1"
          REDIS_CACHE_URL: redis://127.0.0.1:6379
          REDIS_QUEUE_URL: redis://127.0.0.1:6379
          WORDPRESS_URL: 'https://codefund.io'
```{% endraw %}

This tells our job that we want to run the commands we will define later inside of a container built with the {% raw %}`circleci/ruby:2.6.5-node-browsers`{% endraw %} image, and we want the environment variables listed to be inside of that container.

### 3. Define services

For a typical Rails app, you are probably using Redis for caching or tools like Sidekiq, and you also probably have a database. Defining services in your config allows us to use additional containers to run these types of tools. We use Redis in the app, but it is not needed for running the tests.

{% raw %}```yaml
jobs:
  build:
    docker:
      - image: circleci/ruby:2.6.5-node-browsers
        environment:
          PG_HOST: localhost
          PG_USERNAME: ubuntu
          RAILS_ENV: test
          RACK_ENV: test
          DEFAULT_HOST: codefund.io
          PARALLEL_WORKERS: "1"
          REDIS_CACHE_URL: redis://127.0.0.1:6379
          REDIS_QUEUE_URL: redis://127.0.0.1:6379
          WORDPRESS_URL: 'https://codefund.io'
      - image: circleci/postgres:11.2
        environment:
          POSTGRES_USER: ubuntu
          POSTGRES_DB: code_fund_ads_test
```{% endraw %}

### 4. Now we have defined our build step, we need to set our working directory.

{% raw %}```yaml
working_directory: ~/repo
```{% endraw %}

### 5. Add steps

Now it is time to run commands inside of our container. We will start by checking out the code.

{% raw %}```yml
steps:
  - checkout
```{% endraw %}

### 6. Add dependencies

We may need to add some additional dependencies in our container. You can do so by using {% raw %}`run`{% endraw %} and tools like APT or curl.

{% raw %}```yaml
- run: |
    sudo apt-get update
    sudo apt-get install -y postgresql-client
    curl -o- -L https://yarnpkg.com/install.sh | bash
```{% endraw %}

### 7. Caching

Thankfully, CircleCI provides some good documentation for getting started with your tools of choice for caching dependencies. I recommend checking that out, which also has some examples.

[Cache Documentation](https://circleci.com/docs/2.0/caching/)

The first step is to restore the cache from previous builds if it exists.

{% raw %}```yml
- restore_cache:
    name: Restore gem cache
    keys:
      - gem-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "Gemfile.lock" }}
      - gem-cache-v4-{{ arch }}-{{ .Branch }}
      - gem-cache-v4-{{ arch }}
      - gem-cache-v4
- restore_cache:
    name: Restore yarn cache
    keys:
      - yarn-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "yarn.lock" }}
      - yarn-cache-v4-{{ arch }}-{{ .Branch }}
      - yarn-cache-v4-{{ arch }}
      - yarn-cache-v4
- run:
    name: Set up assets cache key
    command: find app/javascript -type f -exec md5sum {} \; > dependency_checksum
- restore_cache:
    name: Restore assets cache
    keys:
      - assets-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "dependency_checksum" }}
      - assets-cache-v4-{{ arch }}-{{ .Branch }}
      - assets-cache-v4-{{ arch }}
      - assets-cache-v4
```{% endraw %}

### 8. Bundle, Yarn, and Precompile Assets

Next, we will want to run Bundler and Yarn to install our dependencies if they were not restored from the cache, and precompile our assets.

{% raw %}```yml
- run:
    name: Install gem dependencies
    command: |
      gem install bundler:2.1.1
      bundle check || bundle install --jobs=6 --retry=3 --path vendor/bundle
- run:
    name: Install yarn dependencies
    command: yarn install --ignore-engines --frozen-lockfile
- run:
    name: Precompile assets
    command: RAILS_ENV=test bundle exec rails webpacker:compile
```{% endraw %}

NOTE: You may be able to skip the asset compilation, that is up to you.

### 9. Caching our dependencies

Once we have installed our dependencies, we can save the cache.

{% raw %}```yaml
- save_cache:
    name: Save gem cache
    paths:
      - vendor/bundle
    key: gem-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "Gemfile.lock" }}
- save_cache:
    name: Save yarn cache
    paths:
      - ~/.cache/yarn
    key: yarn-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "yarn.lock" }}
- save_cache:
    name: Save assets cache
    paths:
      - public/packs-test
      - tmp/cache/webpacker
    key: assets-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "dependency_checksum" }}
```{% endraw %}

### 10. Setup Database

One last item we need to take care of prior to running the tests and linters is setting up our database.

{% raw %}```yaml
- run:
    name: Set up DB
    command: bundle exec rails db:drop db:create db:structure:load --trace
```{% endraw %}

### 11. Run Tests

Now we can finally run our tests. The first thing we do is run a Zeitwerk check. If this fails, we will want to fail the build. We have added this step due to a bug slipping out that we didn't catch and have found it useful. Next we will run our tests, and save any artifacts from that. We use the [minitest-reporters](https://github.com/kern/minitest-reporters) gem, which will save screenshots of failing system tests, which we will want to see if the build fails. The reason we have {% raw %}`set +e`{% endraw %} in there is so that the store artifacts step will run if the system tests fail.

{% raw %}```yaml
- run:
    name: Run zeitwerk check
    command: bundle exec rails zeitwerk:check
- run:
    name: Run tests
    command: |
      bundle exec rails test
      set +e
      bundle exec rails test:system
- store_artifacts:
    path: tmp/screenshots
    destination: screenshots
```{% endraw %}

### 12. Run Linters

The last step is to run any linters or other checks you want.

{% raw %}```yaml
- run:
    name: Run standardrb check
    command: bundle exec standardrb --format progress
- run:
    name: Run ERB lint check
    command: bundle exec erblint app/views/**/*.html.erb
- run:
    name: Run prettier-standard check
    command: yarn run --ignore-engines prettier-standard --check "app/**/*.js"
```{% endraw %}

Now our config is complete and should look like:

{% raw %}```yaml
version: 2.1
jobs:
  build:
    docker:
      - image: circleci/ruby:2.6.5-node-browsers
        environment:
          CAMPAIGN_DEMO_ID: "395"
          PG_HOST: localhost
          PG_USERNAME: ubuntu
          RAILS_ENV: test
          RACK_ENV: test
          DEFAULT_HOST: codefund.io
          PARALLEL_WORKERS: "1"
          REDIS_CACHE_URL: redis://127.0.0.1:6379
          REDIS_QUEUE_URL: redis://127.0.0.1:6379
          WORDPRESS_URL: 'https://codefund.io'
      - image: circleci/postgres:11.2
        environment:
          POSTGRES_USER: ubuntu
          POSTGRES_DB: code_fund_ads_test
    working_directory: ~/repo
    steps:
      - checkout
      - run: |
          sudo apt-get update
          sudo apt-get install -y postgresql-client
          curl -o- -L https://yarnpkg.com/install.sh | bash
      - restore_cache:
          name: Restore gem cache
          keys:
            - gem-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "Gemfile.lock" }}
            - gem-cache-v4-{{ arch }}-{{ .Branch }}
            - gem-cache-v4-{{ arch }}
            - gem-cache-v4
      - restore_cache:
          name: Restore yarn cache
          keys:
            - yarn-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "yarn.lock" }}
            - yarn-cache-v4-{{ arch }}-{{ .Branch }}
            - yarn-cache-v4-{{ arch }}
            - yarn-cache-v4
      - run:
          name: Set up assets cache key
          command: find app/javascript -type f -exec md5sum {} \; > dependency_checksum
      - restore_cache:
          name: Restore assets cache
          keys:
            - assets-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "dependency_checksum" }}
            - assets-cache-v4-{{ arch }}-{{ .Branch }}
            - assets-cache-v4-{{ arch }}
            - assets-cache-v4
      - run:
          name: Install gem dependencies
          command: |
            gem install bundler:2.1.1
            bundle check || bundle install --jobs=6 --retry=3 --path vendor/bundle
      - run:
          name: Install yarn dependencies
          command: yarn install --ignore-engines --frozen-lockfile
      - run:
          name: Precompile assets
          command: RAILS_ENV=test bundle exec rails webpacker:compile
      - save_cache:
          name: Save gem cache
          paths:
            - vendor/bundle
          key: gem-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "Gemfile.lock" }}
      - save_cache:
          name: Save yarn cache
          paths:
            - ~/.cache/yarn
          key: yarn-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "yarn.lock" }}
      - save_cache:
          name: Save assets cache
          paths:
            - public/packs-test
            - tmp/cache/webpacker
          key: assets-cache-v4-{{ arch }}-{{ .Branch }}-{{ checksum "dependency_checksum" }}
      - run:
          name: Set up DB
          command: bundle exec rails db:drop db:create db:structure:load --trace
      - run:
          name: Run zeitwerk check
          command: bundle exec rails zeitwerk:check
      - run:
          name: Run tests
          command: |
            bundle exec rails test
            set +e
            bundle exec rails test:system
      - store_artifacts:
          path: tmp/screenshots
          destination: screenshots
      - run:
          name: Run standardrb check
          command: bundle exec standardrb --format progress
      - run:
          name: Run ERB lint check
          command: bundle exec erblint app/views/**/*.html.erb
      - run:
          name: Run prettier-standard check
          command: yarn run --ignore-engines prettier-standard --check "app/**/*.js"
```{% endraw %}

This is the configuration that we currently use for CodeFund, which you can find [here](https://github.com/gitcoinco/code_fund_ads/blob/master/.circleci/config.yml).

While this setup will work great, there are some enhancements we can add like parallelism, which we will explore in a future post.

_Special thanks to the team at CircleCI for their feedback on this post._


*[This post is also available on DEV.](https://dev.to/codefund/ci-for-ruby-on-rails-circleci-4lkn)*


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
