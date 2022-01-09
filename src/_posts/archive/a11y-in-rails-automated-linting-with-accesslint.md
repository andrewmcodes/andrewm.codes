---
series: null
featured: false
title: "A11Y in Rails: Automated Linting with AccessLint\U0001F389"
description: 'Accessibility (A11Y) testing cannot be fully automated, and requires special attention in order to ge...'
urls:
  dev_to: 'https://dev.to/andrewmcodes/a11y-in-rails-automated-linting-with-accesslint-1618'
tags:
  - rails
  - a11y
  - tutorial
  - beginners
categories: tutorial
date: '2020-03-12T07:41:04Z'
lastmod: '2022-01-09T13:36:05.976Z'
---

## AccessLint

According to their documentation, [AccessLint] is:

> AccessLint brings automated web accessibility testing into your development workflow. When a pull request is opened, AccessLint reviews the changes and comments with any new accessibility issues, giving you quick, timely, and targeted feedback, before code goes live.

We will be creating a demo app to showcase how to utilize AccessLint on your projects. The completed code can be found [here.]

### Setup

Let's create a new Rails app and `cd` into it:

```sh
rails new access_lint_demo
cd access_lint_demo
```

Install dependencies:

```sh
bundle install
yarn install
```

And setup the database:

```sh
bin/rails db:setup
```

Now, let's start the Rails server:

```shell
rails s
```

If you want to run the `webpack-dev-server`, run this in another tab:

```shell
bin/webpack-dev-server
```

If you navigate to `localhost:3000` in your browser, you should see the Rails welcome page:

![rails_welcome_page]

### Create Repository

Open GitHub and create a new repository. I named mine `access_lint_demo`.

Open your command line again and let's upstream our code.

```sh
git add .
git commit -m "first commit"
git remote add origin https://github.com/YOUR_USERNAME/access_lint_demo.git
git push -u origin master
```

Your code should now be online in your repo.

### Configure AccessLint

Navigate to [AccessLint] in your browser, and click `Sign in with Github`:

![access_lint_home_page]

After you authenticate with GitHub, you should be redirected back to the AccessLint setup page. Click `Set up a new installation`:

![access_lint_setup]

You should get redirected to the AccessLint app on the GitHub Marketplace. Click `Open Source` under the `Pricing and setup` header, and then `Install it for free`:

![github_marketplace]

Choose whether you want to install the AccessLint app for all your repos or specifically select your demo repo, and accept the permissions.

AccessLint should now be installed!

![access_lint_dashboard]

### Testing

Let's test it out on a new branch. Run the following in your terminal:

```sh
git checkout -b access-lint-test
```

This should create a new branch in your demo repo. Now, let's scaffold some code:

```sh
bin/rails g scaffold Post title:string content:text
bin/rails db:migrate
```

This will scaffold out some resources for us and add `Post` to our database schema. Most importantly, it will create some new views.

Restart your Rails server and open `localhost:3000/posts` to make sure everything is working correctly

![posts_index_page]

Let's also make a change to `app/views/posts/_form.html.erb` that will trigger a failing lint. We are going to add an inaccessible image to the Post index page:

Add the following to `app/views/posts/index.html.erb`:

```html
<img
  src="https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1352&q=80"
/>
```

Since this image does not have an `alt` attribute, it should be flagged by AccessLint.

Let's commit this code to see if that is correct:

```sh
git add .
git commit -m "create Post resource"
git push --set-upstream origin access-lint-test
```

Now open the repo on GitHub and open a pull request for these changes:

![github_new_pr]

AccessLint should run automatically if we have set it up correctly. After it runs, it should flag our missing `alt` attribute:

![failing_access_lint]

Let's follow the instructions AccessLint has given us to fix the issue and add an `alt` tag to our image:

```html
<img
  alt="person using MacBook Pro"
  src="https://images.unsplash.com/photo-1486312338219-ce68d2c6f44d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1352&q=80"
/>
```

Let's commit this code to see if that fixes the issue:

```sh
git add .
git commit -m "add alt attribute to image on Post#index"
git push
```

If all is well, the AccessLint check should now pass!

![passing_access_lint]

## Summary

AccessLint is a helpful tool if you want to automated web accessibility testing in your Rails app. Unfortunately, the tool is a bit limited currently.

From the documentation:

> Note that server-side code (e.g. image_tag and label_tag in Rails) is not evaluated. Only fully formed HTML tags will be tested.

Regardless, AccessLint is a nice way to start introducing accessibility testing. Accessibility is very important when developing on the web, and this tool will help make sure your code does not prevent users from interacting with your web app. In future posts, we will continue investigate tools to help us with accessibility in our Rails apps.

As mentioned at the beginning of this post, you cannot fully automate accessibility testing away, and none of these tools are substitutes for actually learning accessibility best practices.

## Resources

- [W3C: Accessibility]
- [The A11Y Project]
- [Accessibility on Rails]


[AccessLint]: https://accesslint.com
[here]: https://github.com/andrewmcodes/access_lint_demo
[rails_welcome_page]: https://dev-to-uploads.s3.amazonaws.com/i/prwqk92m70wgn1ddk1d6.jpg
[access_lint_home_page]: https://dev-to-uploads.s3.amazonaws.com/i/lbprkt2tbw896u55cgb0.jpg
[access_lint_setup]: https://dev-to-uploads.s3.amazonaws.com/i/gbaaxts5xc5r5j5h6mga.jpg
[github_marketplace]: https://dev-to-uploads.s3.amazonaws.com/i/vd45o2btqirbuan9ww93.jpg
[access_lint_dashboard]: https://dev-to-uploads.s3.amazonaws.com/i/2v0qsfyz3lr0l966uiqq.jpg
[posts_index_page]: https://dev-to-uploads.s3.amazonaws.com/i/hrg37lm6h228pdigdsq0.jpg
[github_new_pr]: https://dev-to-uploads.s3.amazonaws.com/i/xn951kddg8is90e3h3yd.jpg
[failing_access_lint]: https://dev-to-uploads.s3.amazonaws.com/i/9l2azcm564jzsd26g2qg.jpg
[passing_access_lint]: https://dev-to-uploads.s3.amazonaws.com/i/ygmci46vcwlf8cqctyzh.jpg
[W3C: Accessibility]: https://www.w3.org/standards/webdesign/accessibility
[The A11Y Project]: https://a11yproject.com
[Accessibility on Rails]: https://reinteractive.com/posts/355-accessibility-on-rails
