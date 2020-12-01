---
categories:
  - post
title: 'Rails 6 Band-Aid for Webpacker::Manifest::MissingEntryError'
date: '2020-05-13T23:47:04.114Z'
excerpt: >-
  At CodeFund, we try to keep our dependencies, including Rails, as up to date
  as possible. We upgraded...
thumb_img_path: >-
  https://res.cloudinary.com/practicaldev/image/fetch/s--5PHOSsNU--/c_imagga_scale,f_auto,fl_progressive,h_420,q_auto,w_1000/https://dev-to-uploads.s3.amazonaws.com/i/faaghdvraaxw5mc2fdby.jpg
comments_count: 1
positive_reactions_count: 20
tags:
  - rails
  - webpacker
  - ruby
  - testing
dev_to_url: >-
  https://dev.to/andrewmcodes/rails-6-band-aid-for-webpacker-manifest-missingentryerror-1o21
layout: post
---

At [CodeFund](https://codefund.io), we try to keep our dependencies, including Rails, as up to date as possible. We upgraded to Rails 6 a few months ago, and I've pretty much forgotten any issues we ran into during the upgrade. For what it's worth, the upgrade was very smooth, but there was one issue we ran into that was lost in my memories before a friend showed me a familiar error message today:

{% raw %}```sh

# Webpacker::Manifest::MissingEntryError:

# Webpacker can't find foo/bar in /app/public/packs-test/manifest.json. Possible causes:

# 1. You want to set webpacker.yml value of compile to true for your environment

# unless you are using the `{% endraw %}webpack -w{% raw %}` or the webpack-dev-server.

# 2. webpack has not yet re-run to reflect updates.

# 3. You have misconfigured Webpacker's config/webpacker.yml file.

# 4. Your webpack configuration is not creating a manifest.

# Your manifest contains:

# {

# }

````{% endraw %}

The error essentially is letting you know that Webpacker tried to locate the {% raw %}`foo/bar`{% endraw %} asset entry in the {% raw %}`manifest.json`{% endraw %} file that gets generated when Webpacker compiles your test assets, but it could not find it. Even more interesting, the manifest is completely empty.

It is worth noting that I _only ran into this issue in my test environment_, which is exactly what was happening to my buddy. If your Webpacker config is close to the default, assets are precompiled into {% raw %}`public/packs-test/*`{% endraw %}, which you an see on the second line of the error above.

An issue was created on Webpacker's GitHub repo that basically describes this scenario. It is [issue # 1494](https://github.com/rails/webpacker/issues/1494) if you are curious. However, all of the solutions that worked for others were not working for me, nor my friend who had also found the same issue.

At the time, I figured that we had incorrectly configured something and eventually gave up trying to find the cause and instead focused on finding a solution. It is also worth noting that we are using Minitest at CodeFund, but my friend was using Rspec, which rules out one of my earlier ideas that this could be a Minitest specific issue.

I am still not quite sure the cause, and one of my hopes for posting this article is that someone else has run across this and actually fixed the core issue instead of the band-aid I chose to go with.

If you encounter this type of error in your tests while upgrading to Rails 6, here is one way of solving it:

{% raw %}```ruby
# test/test_helper.rb

unless Webpacker.compiler.fresh?
  puts "== Webpack compiling =="
  Webpacker.compiler.compile
  puts "== Webpack compiled =="
end
```{% endraw %}

Adding this method in your {% raw %}`test_helper`{% endraw %} or {% raw %}`spec_helper`{% endraw %} before the tests run will force Webpacker to make sure the test-packs are present and up to date, and if not it will compile them. If you do some source diving, you will see this comment above the {% raw %}`fresh?`{% endraw %} method in {% raw %}`Webpacker::Compiler`{% endraw %}:

> Returns true if all the compiled packs are up to date with the underlying asset files.

The reason the manifest is empty is because Webpacker needs to be compiled, because the currently compiled packs are not up to date or were never generated in the first place. Webpacker is supposed to do this automatically, but for my friend and I, it wasn’t.

You can see the usage of this in [CodeFund's {% raw %}`test_helper.rb`{% endraw %}](https://github.com/gitcoinco/code_fund_ads/blob/5f9a7165b7a49ed73a81c7987e8a13ba18f9e0a6/test/test_helper.rb# L22). If you try to run the test suite and {% raw %}`public/packs-test`{% endraw %} has not been created or the test packs are not up to date, you will see this in your terminal:

{% raw %}```sh
➜ bin/rails test
== Webpack compiling ==
== Webpack compiled ==

# Running tests with run options --seed 1234:

...
```{% endraw %}

As to why this is happening, I am still not sure. I am still leaning towards this being caused from a misconfiguration or some behavior specific to our setup, but after being asked about it today, I figured it was worth sharing in case you run across it in your own app.

If you have run into this before and fixed the underlying cause, please leave a comment below or mention me on [Twitter](https://twitter.com/andrewmcodes)! I will make sure to update this post if we up solving it. In the meantime, the solution above is working great for us.

Happy ~~coding~~ debugging!!

*[This post is also available on DEV.](https://dev.to/andrewmcodes/rails-6-band-aid-for-webpacker-manifest-missingentryerror-1o21)*


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
