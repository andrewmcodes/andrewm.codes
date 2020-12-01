---
categories:
  - post
title: 'Rails Coverage Tools: CodeFactor'
date: '2020-03-19T02:35:00.170Z'
excerpt: >-
  CodeFactor   According to their documentation:   CodeFactor instantly performs
  Code Review w...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--r3fxyj27--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/p4417i8qwul797crls6p.jpg
comments_count: 0
positive_reactions_count: 10
tags:
  - rails
  - beginners
  - ruby
  - tutorial
dev_to_url: 'https://dev.to/andrewmcodes/rails-coverage-tools-codefactor-3ee2'
layout: post
---

# [CodeFactor](https://codefactor.io)

According to their documentation:

> CodeFactor instantly performs Code Review with every GitHub Commit or PR. Zero setup time. Get actionable feedback within seconds. Customize rules, get refactoring tips and ignore irrelevant issues.

In addition to automated code review, CodeFactor also has auto-fix functionality, which is pretty cool.

For Rails apps specifically, CodeFactor can check:

- Yamllint
- ESLint
- stylelint
- Rubocop

If this sounds interesting, let's look at how to set this up.

## Tutorial

We will be creating a demo app to showcase how to utilize CodeFactor on your projects. The completed code can be found [here](https://github.com/andrewmcodes/codefactor_demo) if you'd like to just look over that.

If you'd like to build it together, let's get started!

### Setup

Let's create a new Rails app and {% raw %}`cd`{% endraw %} into it:

{% raw %}```sh
rails new codefactor_demo
cd codefactor_demo

````{% endraw %}

### Create Repository

Open GitHub and create a new repository. I named mine {% raw %}`codefactor_demo`{% endraw %}.

Open your command line again and let's upstream our code.

{% raw %}```sh
git add .
git commit -m "first commit"
git remote add origin https://github.com/YOUR_USERNAME/codefactor_demo.git
git push -u origin master
```{% endraw %}

Your code should now be online in your repo.

### Configuration

Navigate to [codefactor.io](codefactor.io) and log in with your preferred method. I chose to use my GitHub account.

![codefactor_landing_page_1](https://dev-to-uploads.s3.amazonaws.com/i/kpmyaynxl27u2wj7m0c8.jpg)

Once logged in, you should be taken to your dashboard.

### Add Repository

Let's add a new repository. From your CodeFactor dashboard, click {% raw %}`Add`{% endraw %}, next to {% raw %}`Repositories`{% endraw %}:

![codefactor_dashboard_2](https://dev-to-uploads.s3.amazonaws.com/i/sjzxqhdmb7y02xask5n4.jpg)

You will be taken to a screen that will let you search and select your desired repo. I am adding our demo project repo:

![codefactor_add_repository_3](https://dev-to-uploads.s3.amazonaws.com/i/mco0bzqakhopqvknbtng.jpg)

Click the {% raw %}`Import`{% endraw %} button to import the repository.

Once your repository has been imported, it will show up on your dashboard:

![codefactor_updated_dashboard_4](https://dev-to-uploads.s3.amazonaws.com/i/qla2wc05dejze7zx0olp.jpg)

If we click on our repo, we will be taken to a show page for our repo:

![codefactor_project_page_5](https://dev-to-uploads.s3.amazonaws.com/i/4z3mam2v9268hv5jpgng.jpg)

From here you can look at information about your repository and configure settings for the tools CodeFactor will use to check your repo.

### README Badge

If we would like to add the CodeFactor README badge to our project, click the badge in the top right corner of the project page:

![codefactor_badge_6](https://dev-to-uploads.s3.amazonaws.com/i/1ucwzj36wn04cbj9ap0s.jpg)

This will open a modal with a few format options for our badge. I simply copied the markdown code and pasted it on my README.

This badge should update as your code quality changes according to CodeFactor.

## Summary

CodeFactor is a neat tool if you'd like to run some standard linters on your Rails project, like Rubocop and ESLint. The unfortunate part is that it doesn't look like you can add in tools other than the ones provided. The auto-fix functionality is really helpful if you'd not only like to run the linters but add a commit to the branch that fails checks.

Overall, I think this is a tool worth checking out. However, since I don't personally use the available tools for Rails projects, it wasn't as helpful to me personally as I hoped. Hopefully you will find different!

### Helpful links

- [CodeFactor](https://www.codefactor.io)
- [Demo repo](https://github.com/andrewmcodes/codefactor_demo)
- [CodeFactor show page for demo repo](https://www.codefactor.io/repository/github/andrewmcodes/codefactor_demo)
- [CodeFactor Default Configs](https://github.com/codefactor-io/default-configs)

Happy coding!

P.S. If you aren't sure how to set up ESLint, Rubocop, or the other listed linters, leave a comment or message me on [Twitter](https://twitter.com/andrewmcodes) and let me know if you'd like a post about this!

*[This post is also available on DEV.](https://dev.to/andrewmcodes/rails-coverage-tools-codefactor-3ee2)*


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
