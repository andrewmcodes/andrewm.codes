---
series: null
featured: false
title: Stopping a runaway Rails server
description: 'Many of us have been there. You hit ctrl-c on you Ruby on Rails server, but nothing happens. No matte...'
urls:
  dev_to: 'https://dev.to/andrewmcodes/stopping-a-runaway-rails-server-7mg'
tags:
  - rails
  - ruby
  - productivity
  - gems
categories: tutorial
date: '2020-02-11T03:43:19Z'
last_modified_at: '2022-01-29T17:01:41.574Z'
---

_Many of us have been there. You hit `ctrl-c` on you Ruby on Rails server, but nothing happens. No matter what keys you hit on your keyboard, the Rails server is still running, and you can't stop it. You have a runaway train on your hands._

## The Problem

If you have ever developed with Ruby on Rails, there is a good chance you have encountered a runaway Rails server. This is basically an instance of the Ruby on Rails server that you cannot easily stop.

Two examples of when you may need this is if you try to start your Rails server and get an error message that one is already running, or you get into a weird state with pry and `ctrl-c` won't stop the server in a timely manner.

Regardless of how you got to this point isn't really important, you have a runaway train on your hands, and you need to stop it.

Here is how you can do that:

## Shutup

`shutup` is a gem to help you quickly stop a running Rails server.

To install the gem, make sure you have Ruby installed.

Type the following into your command line:

```sh
gem install shutup
```

Now, whenever you have a Rails server you want to stop, just type the following in your command line to shut it down:

```sh
shutup
```

If the command succeeded, you should see something like this:

```sh
➜ shutup
Killed process id: 46707
```

If it fails, you will see:

```sh
➜ shutup
Error reading the pid file.
```

## Conclusion

You could achieve the same effect with Bash or ZSH aliases, or just running the entire process by hand, but this gem removes the need to do that. It's a simple gem, but it's one I install whenever I install a new version of Ruby.

Check it out at: [lorenzosinisi/shutup](https://github.com/lorenzosinisi/shutup)

Happy coding!!
