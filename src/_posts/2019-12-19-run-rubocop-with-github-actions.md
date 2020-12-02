---
categories:
  - post
title: Run Rubocop with GitHub Actions
date: '2019-12-19T02:10:52.680Z'
excerpt: >-
  GitHub Actions are a great new tool that you have at your disposal if you are
  using GitHub. There is...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--3hGkKUbx--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://thepracticaldev.s3.amazonaws.com/i/wx4vtsd90muyfzf99smc.png
comments_count: 0
positive_reactions_count: 12
tags:
  - rails
  - ruby
  - github
  - webdev
dev_to_url: 'https://dev.to/andrewmcodes/run-rubocop-with-github-actions-4adp'
layout: post
---

GitHub Actions are a great new tool that you have at your disposal if you are using GitHub. There is a lot you can do with them, but in this article we will focus on how to use actions to run [Rubocop](https://github.com/rubocop-hq/rubocop), a Ruby static code analyzer and code formatter, against a vanilla Rails app, with the help of the [Rubocop Linter Action](https://github.com/andrewmcodes/rubocop-linter-action).

The action uses [GitHub's Checks API](https://developer.github.com/changes/2018-05-07-new-checks-api-public-beta/) to display the results of the action in the UI, to help you better visualize your failing lints.

# What We Will Build

To demonstrate how to use the [Rubocop Linter Action](https://github.com/andrewmcodes/rubocop-linter-action), we will scaffold a small Rails app and add the action. After we get the action working, we will add some configuration options to showcase some of the action's abilities.

# The Code

For this demo, I am using Ruby {% raw %}`2.6.5`{% endraw %} and Rails {% raw %}`6.0.1`{% endraw %}.

First, let's create a new Rails app:

{% raw %}```sh
rails new devto-rubocop-linter-action-demo
cd devto-rubocop-linter-action-demo/

````{% endraw %}

To run the action out of the box, all we need to do is add a workflow file:

{% raw %}```sh
mkdir -p .github/workflows
touch .github/workflows/rubocop.yml
```{% endraw %}

You should now have a file named {% raw %}`rubocop.yml`{% endraw %} inside {% raw %}`.github/workflows`{% endraw %}.

Now, lets configure our workflow to run the [Rubocop Linter Action](https://github.com/andrewmcodes/rubocop-linter-action):

{% raw %}```yml
# .github/workflows/rubocop.yml

name: Rubocop

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Rubocop Linter Action
      uses: andrewmcodes/rubocop-linter-action@v3.0.0.rc2
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```{% endraw %}

This tells GitHub that our action name is "Rubocop", and we are going to run it on the latest ubuntu version available whenever there is a push to the repository.

For our steps, we will first check-out the repository using {% raw %}`actions/checkout@v2`{% endraw %}, which is an action that checks-out your repository under {% raw %}`$GITHUB_WORKSPACE`{% endraw %}, so your workflow can access it.

We will then run a step with the name of {% raw %}`Rubocop Linter Action`{% endraw %} that uses the action with the same name. For this tutorial, we will be using version {% raw %}`3.0.0.rc2`{% endraw %} of the action.

The last step is to pass in a generated GitHub token to the action under the {% raw %}`GITHUB_TOKEN`{% endraw %} environment variable, which will be accessible inside of the action. You can read more about that [here](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/authenticating-with-the-github_token).

Now I am going to create a repository called {% raw %}`devto-rubocop-linter-action-demo`{% endraw %} on GitHub. You can find it [here](https://github.com/andrewmcodes/devto-rubocop-linter-action-demo). After the repository is created, we need to run a few commands to push our action to our master branch.

{% raw %}```sh
git add .
git commit -m "first commit"
git remote add origin https://github.com/andrewmcodes/devto-rubocop-linter-action-demo.git
git push -u origin master
```{% endraw %}

Now if we open our repository on GitHub, under the "Actions" tab, we should see this:

![GitHub Action Tab](https://thepracticaldev.s3.amazonaws.com/i/1lttphdk0uj0lr89spy3.png)

If we click on this action, and wait a few seconds, it should succeed. On the left side of the screen you should see our action name, "Rubocop", and two items underneath it, "Build" and "Rubocop Action".

If you click on "Build", it will show you the build logs for the action.

If you click on "Rubopcop Action", we should see our Rubocop results.

![Rubocop Action Results](https://thepracticaldev.s3.amazonaws.com/i/41unrunahp55dn2tk2uh.png)

Pretty cool! We can now see all of the failures for the action on our fresh Rails app, using just the [Rubocop Linter Action](https://github.com/andrewmcodes/rubocop-linter-action) and Rubocop defaults. Notice that we didn't even need to add Rubocop to our Gemfile!

# Advanced Configuration

The real power of the action is that you can configure it to work how you want. It also works even better with pull requests, which is what I will show you now.

First, let's create a new branch:

{% raw %}```sh
git checkout -b advanced-rubocop-action-config
```{% endraw %}

Next, create a Rubocop config file:

{% raw %}```sh
touch .rubocop.yml
```{% endraw %}

Inside of that file, let's add:

{% raw %}```yml
# .rubocop.yml

require:
  - rubocop-performance
  - rubocop-rails
```{% endraw %}

What this does is tell Rubocop that we want to use the [Rubocop Performance](https://github.com/rubocop-hq/rubocop-performance) and [Rubocop Rails](https://github.com/rubocop-hq/rubocop-rails) extensions. Notice that we have not added these gems to our Gemfile.

Now, lets create a config file for our action:

{% raw %}```sh
mkdir -p .github/config
touch .github/config/rubocop_linter_action.yml
```{% endraw %}

This will be the file that we use to configure the action. Let's add some config options to it:

{% raw %}```yml
# .github/config/rubocop_linter_action.yml

rubocop_extensions:
  - 'rubocop-rails'
  - 'rubocop-performance': '1.5.1'
```{% endraw %}

What this does is tell the action we want to use the Rubocop Rails and Rubocop Performance extensions. Specifically, we want to use the latest version of {% raw %}`rubocop-rails`{% endraw %}, and version 1.5.1 of {% raw %}`rubocop-performance`{% endraw %}.

Let's commit these and see what happens:

{% raw %}```sh
git add .
git commit -m "add rubocop and rubocop-linter-action config files"
git push --set-upstream origin advanced-rubocop-action-config
```{% endraw %}

If we go to our repo on GitHub, we should see a banner with our branch name and a button that says "Compare & pull request". If we click that, we should be taken to a pull request edit page. Click "Create Pull Request" button to open our new pull request.

Now that our pull request is open, click the "Checks" tab, and we should see that we have a few more offenses now that we have added our plugins:

![Updated Config Rubocop Action Results](https://thepracticaldev.s3.amazonaws.com/i/dpuoc1mbc4bo23h0c3qc.png)

If we click on one of the checks, you should be taken to the location in the file where lint was recorded:

![Inline Rubocop Action Results](https://thepracticaldev.s3.amazonaws.com/i/ndyp4yyoa3fs4nf7eeb3.png)

# In Summary

There are lots more changes we can add to finely tune [Rubocop Linter Action](https://github.com/andrewmcodes/rubocop-linter-action) to run the way we want. A few of my favorites are the ability to only run Rubocop against the diff and bundling our Gemfile instead of installing extensions from [RubyGems.org](https://rubygems.org) directly.

If this has interested you, I would suggest checking out the [action documentation](https://rubocop-linter-action.readthedocs.io/en/v3.0.0.rc2/) and the [GitHub repo](https://github.com/andrewmcodes/rubocop-linter-action).

Version 3.0.0.rc2 is in a pre-release phase, but I would love if you give it a try and let me know what issues you come across!

Happy Coding! 😃

*[This post is also available on DEV.](https://dev.to/andrewmcodes/run-rubocop-with-github-actions-4adp)*


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
