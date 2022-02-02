---
series: null
featured: false
title: Automating Ruby Gem Releases with GitHub Actions
description: 'Whether you are a gem maintaining machine or new to the world of authoring gems, this tutorial is for...'
urls:
  dev_to: 'https://dev.to/andrewmcodes/automating-ruby-gem-releases-with-github-actions-1m1c'
tags:
  - ruby
  - tutorial
  - actions
  - gem
categories: tutorial
date: '2021-02-20T00:33:07Z'
last_modified_at: '2022-01-29T17:01:41.562Z'
---

Whether you are a gem maintaining machine or new to the world of authoring gems, this tutorial is for you. Adhereing to SemVer and keeping an updated changelog are both important components in well maintained open source, but they are also a pain at times. This tutorial will walk you through a simple way to create a release process that automates the small, but important, parts of maintaining a Ruby gem.

## Release Please

[Release Please Action](https://github.com/google-github-actions/release-please-action) is a GitHub action created by Google to automate releases with [Conventional Commit Messages](https://www.conventionalcommits.org/en/v1.0.0/). As you merge PR's into your main branch, the action will create/update a new release branch that automatically adds your commits to a changelog and bumps the version according to your commits. When you're ready to release your changes, merging the PR will cause a new GitHub release to be created and released. We can even automate publishing to package registries like [RubyGems](https://rubygems.org)!

## Conventional Commits

This article will assume you are familiar with [Conventional Commits](<(https://www.conventionalcommits.org/en/v1.0.0/)>). Here is a brief overview of the important prefixes, pulled from [the action's README](https://github.com/google-github-actions/release-please-action#whats-a-release-pr)

The most important prefixes you should have in mind are:

- `fix`: which represents bug fixes, and correlates to a SemVer patch.
- `feat`: which represents a new feature, and correlates to a SemVer minor.
- `feat!`:, or `fix!:`, `refactor!:`, etc., which represent a breaking change (indicated by the !) and will result in a SemVer major.

I've considered doing a longer article about how I use conventional commit messages in my workflow, so let me know if you'd be interested in that.

## Testing it out

I'm going to create a new gem to demo this action's functionality:

```bash
bundler gem release-please-demo --test=rspec --ci=github
cd release-please-demo
bundle install
```

> Skip to the bottom if you'd just like to see the result!

Next we will need to update our gemspec if we want to publish the gem. I'm not going to go over this right now, but if you're curious to learn more about how to setup a Ruby gem specification, I suggest [checking out this great article by Piotr Murach](https://piotrmurach.com/articles/writing-a-ruby-gem-specification/).

This is what my `release-please-demo.gemspec` looks like:

```ruby
# frozen_string_literal: true

require_relative "lib/release/please/demo/version"

Gem::Specification.new do |spec|
  spec.name = "release-please-demo"
  spec.version = Release::Please::Demo::VERSION
  spec.authors = ["Andrew Mason"]
  spec.email = ["andrewmcodes@protonmail.com"]
  spec.summary = "Demo of release-please."
  spec.description = "A demo gem showing how to use release-please to automatically version gems."
  spec.homepage = "https://github.com/andrewmcodes/release-please-demo"
  spec.license = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")
  spec.metadata = {
    "bug_tracker_uri" => "#{spec.homepage}/issues",
    "changelog_uri" => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "documentation_uri" => spec.homepage.to_s,
    "homepage_uri" => spec.homepage.to_s,
    "source_code_uri" => spec.homepage.to_s,
  }

  spec.files =
    Dir.chdir(File.expand_path(__dir__)) do
      `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
    end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
```

Since the purpose of this article is to focus on the release cycle, we are just going to use the gem that Bundler scaffolded without any code changes. If you were building you own gem, this is the part where you would add functionality to the gem.

## Setting up the action

Let's build our release action:

```sh
touch .github/workflows/release.yml
```

Open this in your code editor of choice.

First we are going to set the name of the action, and when it should run. We only want this action to run when something is merged into the default branch, or a release branch depending on your workflow. I name my default branch main, so every time code gems pushed to main, we will run this action.

```yaml
# .github/workflows/release.yml

name: release

on:
  push:
    branches:
      - main
```

Next we need to setup a job for the [Release Please Action](https://github.com/google-github-actions/release-please-action). Option descriptions are annotated with comments, but please [view the official configuration documentation](https://github.com/google-github-actions/release-please-action#configuration) to learn more.

```yaml
jobs:
  release-please:
    runs-on: ubuntu-latest
    steps:
      - uses: GoogleCloudPlatform/release-please-action@v2
        id: release
        with:
          # The release type
          release-type: ruby
          # A name for the artifact releases are being created for
          # which is the name of our gem
          package-name: release-please-demo
          # Should breaking changes before 1.0.0 produce minor bumps?
          bump-minor-pre-major: true
          # Path to our version file to increment
          version-file: "lib/release/please/demo/version.rb"
```

We are going to do some more cool things in a second but lets go ahead and see what this produces. Create a new GitHub repo, commit everything, and push it up. As a note, Bundler adds a failing test condition by default when you scaffold the gem, so if you added the `--ci=github` flag when you created the gem, the generated `.github/workflows/main.yml` action will fail unless you remove the failing test. I'll let you debug that on your own for now.

The release action will run once you push your changes to the main branch. Your initial run output should look like this:

```
Run GoogleCloudPlatform/release-please-action@v2
✖ No merged release PR found
✖ Unable to build candidate
✔ found 4 commits since beginning of time
✖ no user facing commits found since beginning of time
```

This output says:

- A merged release PR was not found, which we will talk about in a moment
- There is no build candidate
- There were 4 commits found in the repo
- None of those commits were user facing, aka they weren't features or bug fixes

Just for reference - this is the output of `git log --one-line` so you can see my four commits:

```bash
9a4d62b (HEAD -> main, origin/main) build: add release action (#1)
1b0bcd4 chore: bundle install
7a30c6d chore: update gemspec
c793bca chore: initial commit
```

As we can see, none were features or fixes, so the action did not create a release PR.

## Creating a release

I'm going to cheat and an empty commit for a feature:

```bash
git commit --allow-empty -m "feat: add a feature"
git push -u origin main
```

Our release action should run and this time find a user facing commit and open a new release PR. The PR will increment the version number and create a new, or edit an existing, Changelog.

![Generated release pr](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/2mxv0klralttr9hmlsip.png)

Note: For a gem without prior releases, I wasn't able to find a way to prevent a full point release. You _could_ get around this by editing the release PR to match the inital version number you'd like before merging. This is not an issue with projects with prior releases.

## Publish to RubyGems

Our current setup is great if we just want to automate changelog creation and versioning, but we would still have to publish the gem ourselves after the release was created. Fortunately, we can hook into our existing workflow to automate publishing as well!

You may have noticed we gave our first step an id of `release`. By doing this, we can check the output of that step in other steps and act accordingly.

### Setup Steps

If the output of our release step is `release_created`, we will checkout the repo, install Ruby, and run `bundle install`:

```yaml
jobs:
  release-please:
    runs-on: ubuntu-latest
    steps:
      - uses: GoogleCloudPlatform/release-please-action@v2
        id: release
        with:
          release-type: ruby
          package-name: release-please-demo
          bump-minor-pre-major: true
          version-file: "lib/release/please/demo/version.rb"
      # Checkout code if release was created
      - uses: actions/checkout@v2
        if: ${{ steps.release.outputs.release_created }}
      # Setup ruby if a release was created
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.0.0
        if: ${{ steps.release.outputs.release_created }}
      # Bundle install
      - run: bundle install
        if: ${{ steps.release.outputs.release_created }}
```

### Publish Step

If a release was created, we will setup gem credentials, build the gem, and push it to RubyGems.

You will **need** to [get an API token from RubyGems](https://guides.rubygems.org/api-key-scopes/) and [add it to your repository secrets](https://docs.github.com/en/actions/reference/encrypted-secrets#creating-encrypted-secrets-for-an-environment). I named mine `RUBYGEMS_AUTH_TOKEN` but you can set the name to whatever you'd like.

```yaml
- name: publish gem
  run: |
    mkdir -p $HOME/.gem
    touch $HOME/.gem/credentials
    chmod 0600 $HOME/.gem/credentials
    printf -- "---\n:rubygems_api_key: ${GEM_HOST_API_KEY}\n" > $HOME/.gem/credentials
    gem build *.gemspec
    gem push *.gem
  env:
    # Make sure to update the secret name
    # if yours isn't named RUBYGEMS_AUTH_TOKEN
    GEM_HOST_API_KEY: "${{secrets.RUBYGEMS_AUTH_TOKEN}}"
  if: ${{ steps.release.outputs.release_created }}
```

Note: I got this code straight from [GitHub's action documentation](https://docs.github.com/en/actions/guides/building-and-testing-ruby#publishing-gems).

## Release and Publish

Our final action:

```yaml
# .github/workflows/release.yml

name: release

on:
  push:
    branches:
      - main

jobs:
  release-please:
    runs-on: ubuntu-latest
    steps:
      - uses: GoogleCloudPlatform/release-please-action@v2
        id: release
        with:
          release-type: ruby
          package-name: release-please-demo
          bump-minor-pre-major: true
          version-file: "lib/release/please/demo/version.rb"
      # Checkout code if release was created
      - uses: actions/checkout@v2
        if: ${{ steps.release.outputs.release_created }}
      # Setup ruby if a release was created
      - uses: ruby/setup-ruby@v1
        with:
          ruby-version: 3.0.0
        if: ${{ steps.release.outputs.release_created }}
      # Bundle install
      - run: bundle install
        if: ${{ steps.release.outputs.release_created }}
      # Publish
      - name: publish gem
        run: |
          mkdir -p $HOME/.gem
          touch $HOME/.gem/credentials
          chmod 0600 $HOME/.gem/credentials
          printf -- "---\n:rubygems_api_key: ${GEM_HOST_API_KEY}\n" > $HOME/.gem/credentials
          gem build *.gemspec
          gem push *.gem
        env:
          # Make sure to update the secret name
          # if yours isn't named RUBYGEMS_AUTH_TOKEN
          GEM_HOST_API_KEY: "${{secrets.RUBYGEMS_AUTH_TOKEN}}"
        if: ${{ steps.release.outputs.release_created }}
```

Commit, push this code, and wait for your release PR to be updated by our action bot. Once the release PR has been updated, merge the PR into your main branch.

![Release action success](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/mtfi99frqpq9qr5odfnx.png)

Once our release action runs, assuming it succeeds, you should see a new release in GitHub! One great feature of this action is that it will build the release notes from our changelog entries. 🚀

![New GitHub Release](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/km4thpr1h49gauu2uvic.png)

If we check RubyGems, we should see our new gem has been published and is ready to share!

![RubyGems](https://dev-to-uploads.s3.amazonaws.com/uploads/articles/w7se9cw67cfp3xrdz8jw.png)

## Final Thoughts

If you followed the tutorial and don't intend to use your new gem, you should consider yanking it to allow others to use the name in the future.

```bash
gem yank release-please-demo -v 1.0.0
```

One great aspect of the action is that you can use it with other languages or a `.txt` file, allowing you to create consistent pattern across all of your open source. You could enhance the workflow by adding in checks to run the tests before releases and also adding a linter to ensure conventional commits are used. With this workflow, you'll be able to make new releases without pulling down the code and never have to try and remember how you release a project again.

Give it a try and tell me what you think!
