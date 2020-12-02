---
categories:
  - post
title: "A11Y in Rails: Automated Linting with AccessLint\U0001F389"
date: '2020-03-12T08:16:53.035Z'
excerpt: >-
  Accessibility (A11Y) testing cannot be fully automated, and requires special
  attention in order to ge...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--VTUCTlvK--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/s77t59q88yiaco675uqw.jpg
comments_count: 0
positive_reactions_count: 8
tags:
  - rails
  - a11y
  - tutorial
  - beginners
dev_to_url: >-
  https://dev.to/andrewmcodes/a11y-in-rails-automated-linting-with-accesslint-1618
layout: post
---

Accessibility ({% raw %}`A11Y`{% endraw %}) testing cannot be fully automated, and requires special attention in order to get right. There are, however; some tools out there that can help us automate part of it and make it a first class concern.

# AccessLint

According to their documentation, [AccessLint](https://accesslint.com) is:

> AccessLint brings automated web accessibility testing into your development workflow. When a pull request is opened, AccessLint reviews the changes and comments with any new accessibility issues, giving you quick, timely, and targeted feedback, before code goes live.

## Tutorial

We will be creating a demo app to showcase how to utilize AccessLint on your projects. The completed code can be found [here](https://github.com/andrewmcodes/access_lint_demo) if you'd like to just look over that.

If you'd like to build it together, let's get started!

### Setup

Let's create a new Rails app and {% raw %}`cd`{% endraw %} into it:

{% raw %}```sh
rails new access_lint_demo
cd access_lint_demo

````{% endraw %}

Install dependencies:

{% raw %}```sh
bundle install
yarn install
```{% endraw %}

And setup the database:

{% raw %}```sh
bin/rails db:setup
```{% endraw %}

Now, let's start the Rails server:

{% raw %}```shell
rails s
```{% endraw %}

If you want to run the {% raw %}`webpack-dev-server`{% endraw %}, run this in another tab:

{% raw %}```shell
bin/webpack-dev-server
```{% endraw %}

If you navigate to {% raw %}`localhost:3000`{% endraw %} in your browser, you should see the Rails welcome page:

![rails_welcome_page](https://dev-to-uploads.s3.amazonaws.com/i/prwqk92m70wgn1ddk1d6.jpg)

### Create Repository

Open GitHub and create a new repository. I named mine {% raw %}`access_lint_demo`{% endraw %}.

Open your command line again and let's upstream our code.

{% raw %}```sh
git add .
git commit -m "first commit"
git remote add origin https://github.com/YOUR_USERNAME/access_lint_demo.git
git push -u origin master
```{% endraw %}

Your code should now be online in your repo.

### Configuration

Navigate to [AccessLint](https://accesslint.com) in your browser, and click {% raw %}`Sign in with Github`{% endraw %}:

![access_lint_home_page](https://dev-to-uploads.s3.amazonaws.com/i/lbprkt2tbw896u55cgb0.jpg)

After you authenticate with GitHub, you should be redirected back to the AccessLint setup page. Click {% raw %}`Set up a new installation`{% endraw %}:

![access_lint_setup](https://dev-to-uploads.s3.amazonaws.com/i/gbaaxts5xc5r5j5h6mga.jpg)

You should get redirected to the AccessLint app on the GitHub Marketplace. Click {% raw %}`Open Source`{% endraw %} under the {% raw %}`Pricing and setup`{% endraw %} header, and then {% raw %}`Install it for free`{% endraw %}:

![github_marketplace](https://dev-to-uploads.s3.amazonaws.com/i/vd45o2btqirbuan9ww93.jpg)

Choose whether you want to install the AccessLint app for all your repos or specifically select your demo repo, and accept the permissions.

AccessLint should now be installed!

![access_lint_dashboard](https://dev-to-uploads.s3.amazonaws.com/i/2v0qsfyz3lr0l966uiqq.jpg)

### Test it out

Let's test it out on a new branch. Run the following in your terminal:

{% raw %}```sh
git checkout -b access-lint-test
```{% endraw %}

This should create a new branch in your demo repo. Now, let's scaffold some code:

{% raw %}```sh
bin/rails g scaffold Post title:string content:text
bin/rails db:migrate
```{% endraw %}

This will scaffold out some resources for us and add {% raw %}`Post`{% endraw %} to our database schema. Most importantly, it will create some new views.

Restart your Rails server and open {% raw %}`localhost:3000/posts`{% endraw %} to make sure everything is working correctly

![posts_index_page](https://dev-to-uploads.s3.amazonaws.com/i/hrg37lm6h228pdigdsq0.jpg)

Let's also make a change to {% raw %}`app/views/posts/_form.html.erb`{% endraw %} that will trigger a failing lint. We are going to add an inaccessible image to the Post index page:

Add the following to {% raw %}`app/views/posts/index.html.erb`{% endraw %}:

{% raw %}```html
<img src="https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1352&q=80">
```{% endraw %}

Since this image does not have an {% raw %}`alt`{% endraw %} attribute, it should be flagged by AccessLint.

Let's commit this code to see if that is correct:

{% raw %}```sh
git add .
git commit -m "create Post resource"
git push --set-upstream origin access-lint-test
```{% endraw %}

Now open the repo on GitHub and open a pull request for these changes:

![github_new_pr](https://dev-to-uploads.s3.amazonaws.com/i/xn951kddg8is90e3h3yd.jpg)

AccessLint should run automatically if we have set it up correctly. After it runs, it should flag our missing {% raw %}`alt`{% endraw %} attribute:

![failing_access_lint](https://dev-to-uploads.s3.amazonaws.com/i/9l2azcm564jzsd26g2qg.jpg)

Let's follow the instructions AccessLint has given us to fix the issue and add an {% raw %}`alt`{% endraw %} tag to our image:

{% raw %}```html
<img alt="person using MacBook Pro" src="https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1352&q=80">
```{% endraw %}

Let's commit this code to see if that fixes the issue:

{% raw %}```sh
git add .
git commit -m "add alt attribute to image on Post# index"
git push
```{% endraw %}

If all is well, the AccessLint check should now pass!

![passing_access_lint](https://dev-to-uploads.s3.amazonaws.com/i/ygmci46vcwlf8cqctyzh.jpg)

## Summary

AccessLint is a helpful tool if you want to automated web accessibility testing in your Rails app. Unfortunately, the tool is a bit limited currently.

From the documentation:

>Note that server-side code (e.g. image_tag  and label_tag in Rails) is not evaluated. Only fully formed HTML tags will be tested.

Regardless, AccessLint is a nice way to start introducing accessibility testing. Accessibility is very important when developing on the web, and this tool will help make sure your code does not prevent users from interacting with your web app. In future posts, we will continue investigate tools to help us with accessibility in our Rails apps.

As mentioned at the beginning of this post, you cannot fully automate accessibility testing away, and none of these tools are substitutes for actually learning accessibility best practices.

### Helpful links

- [W3C: Accessibility](https://www.w3.org/standards/webdesign/accessibility)
- [The A11Y Project](https://a11yproject.com)
- [Accessibility on Rails](https://reinteractive.com/posts/355-accessibility-on-rails)

Happy coding!

*[This post is also available on DEV.](https://dev.to/andrewmcodes/a11y-in-rails-automated-linting-with-accesslint-1618)*


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
