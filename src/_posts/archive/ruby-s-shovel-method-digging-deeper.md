---
series: null
featured: false
title: 'Ruby''s Shovel Method: Digging Deeper'
description: "Heads up! This is not actually a deep dive \U0001F62C   With everything going on in the world, I almost forgo..."
urls:
  dev_to: 'https://dev.to/andrewmcodes/ruby-s-shovel-method-digging-deeper-5hfm'
tags:
  - ruby
  - devjournal
  - tutorial
  - rails
categories: tutorial
date: '2020-11-22T05:53:26Z'
lastmod: '2022-01-22T07:59:42.954Z'
---

> Heads up! This is not _actually_ a deep dive 😬

With everything going on in the world, I almost forgot how fun it can be to code in Ruby! I am not being sarcastic, its _actually_ really fun!

## What kind of fun?

Earlier, I was reviewing some code in a PR to [Bridgetown](https://github.com/bridgetownrb/bridgetown), and I came across this change:

```diff
- static_template_files << "/Gemfile"
+ static_template_files.push "/Gemfile", "/package.json"
```

Whenever I see small method changes during code review, I find it a helpful mind exercise to consider whether the method actually _needed_ to be changed since there's almost always _a way_ in Ruby. More often than not, this leads me to my favorite type of Ruby: quirky, fun, and a bit magical.

You could even call it _blursed_...🤔

And if we are really being honest, blursed Ruby is my favorite type of Ruby.

## `Array#<<`

Commonly referred to as the "shovel operator", `<<` is a method in Ruby that is commonly used to push an object onto an array, but you can shovel into strings as well.

For example:

```ruby
%w[foo bar] << "baz"
#=> ["foo", "bar", "baz"]
```

> Speaking of blursed Ruby, [check out the example code in the docs for `str << int`](https://ruby-doc.org/core-2.6/String.html#method-i-3C-3C).

## TIL!

Today I `/re(learned|membered)/` you can chain shovels! Not that you _should_....but just in case, know that you _can_.

The following is a blursed example of just that:

![Blursed Ruby Shovel Code Screenshot](https://dev-to-uploads.s3.amazonaws.com/i/yufpo9f1pbnp7y3flt9u.png)

[View gist](https://gist.github.com/andrewmcodes/2e4ba1d60016e065155f0509d3814234)

I realized I was grinning from ear to ear while writing this code. This code will run just fine if you paste it into IRB or Pry, emojis and all! A fun example of what you _can_ do with Ruby, if you wanted to.

## Back to code review

Just because you _can_ do it doesn't mean you should! The readability of swapping the shovel operator with the `Array#push` method is the right call in my opinion. The change got a green check of approval from me.

But, I couldn't resist sharing my blursed example. Hopefully it makes you grin as well.

As I said at the beginning: it's fun to write Ruby!

Happy coding!
