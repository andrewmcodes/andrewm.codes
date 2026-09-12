---
title: Automating Ruby Gem Releases with GitHub Actions
description: "Automate Ruby gem releases with GitHub Actions and Release Please: conventional-commit versioning, changelog generation, and publishing to RubyGems."
urls:
  dev_to: https://dev.to/andrewmcodes/automating-ruby-gem-releases-with-github-actions-1m1c
tags:
  - ruby
  - actions
  - CI
  - gem
date: 2021-02-20 00:33:07.000000000 Z
last_modified_at: 2026-09-11 00:00:00.000000000 Z
categories:
  - tutorials
featured: true
---

Whether you are a gem maintaining machine or new to the world of authoring gems, this tutorial is for you. Adhereing to SemVer and keeping an updated changelog are both important components in well maintained open source, but they are also a pain at times. This tutorial will walk you through a simple way to create a release process that automates the small, but important, parts of maintaining a Ruby gem.

## Release Please

[Release Please Action](https://github.com/googleapis/release-please-action) is a GitHub action created by Google to automate releases with [Conventional Commit Messages](https://www.conventionalcommits.org/en/v1.0.0/). As you merge PR's into your main branch, the action will create/update a new release branch that automatically adds your commits to a changelog and bumps the version according to your commits. When you're ready to release your changes, merging the PR will cause a new GitHub release to be created and released. We can even automate publishing to package registries like [RubyGems](https://rubygems.org)!

## Conventional Commits

This article will assume you are familiar with [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/). Here is a brief overview of the important prefixes, pulled from [the action's README](https://github.com/googleapis/release-please-action#whats-a-release-pr)

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

This is what my `release-please-demo.gemspec` looks like after replacing the `TODO` placeholders that Bundler leaves for the summary, description, and push host, and uncommenting the `rubygems_mfa_required` line (recommended):

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
  spec.required_ruby_version = ">= 3.2.0"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/andrewmcodes/release-please-demo"
  spec.metadata["changelog_uri"] = "https://github.com/andrewmcodes/release-please-demo/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/ .github/ .standard.yml])
    end
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

Next we need to setup a job for the [Release Please Action](https://github.com/googleapis/release-please-action). As of `v4`, configuration moved out of the workflow's `with:` block and into two files that live at the root of your repo: a `release-please-config.json` that describes each package, and a `.release-please-manifest.json` that tracks the current version. Please [view the official configuration documentation](https://github.com/googleapis/release-please/blob/main/docs/manifest-releaser.md) to learn more.

Here is `release-please-config.json` for our gem. Options are annotated with comments (real JSON can't have comments, so strip these before committing):

```jsonc
{
  "$schema": "https://raw.githubusercontent.com/googleapis/release-please/main/schemas/config.json",
  "packages": {
    // "." means the package lives at the repo root
    ".": {
      // The release type
      "release-type": "ruby",
      // The name of our gem
      "package-name": "release-please-demo",
      // Path to the version file to increment
      "version-file": "lib/release/please/demo/version.rb",
      // Where the changelog is written
      "changelog-path": "CHANGELOG.md",
      // Should breaking changes before 1.0.0 produce minor bumps?
      "bump-minor-pre-major": true,
      // Tag releases as v1.2.3 rather than 1.2.3
      "include-v-in-tag": true
    }
  }
}
```

And `.release-please-manifest.json`, seeded with your current version:

```json
{
  ".": "0.1.0"
}
```

Now the workflow itself. It needs `contents: write` and `pull-requests: write` permissions so the action can push the release branch and open the PR, and we pass the built-in `GITHUB_TOKEN`:

```yaml
permissions:
  contents: write
  pull-requests: write

jobs:
  release-please:
    runs-on: ubuntu-latest
    steps:
      - uses: googleapis/release-please-action@v4
        id: release
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
```

We are going to do some more cool things in a second but lets go ahead and see what this produces. Create a new GitHub repo, commit everything, and push it up. As a note, Bundler adds a failing test condition by default when you scaffold the gem, so if you added the `--ci=github` flag when you created the gem, the generated `.github/workflows/main.yml` action will fail unless you remove the failing test. I'll let you debug that on your own for now.

The release action will run once you push your changes to the main branch. Your initial run output should look like this:

```
Run googleapis/release-please-action@v4
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
git commit --allow-empty -m "feat!: add a feature"
git push -u origin main
```

Our release action should run and this time find a user facing commit and open a new release PR. The PR will increment the version number and create a new, or edit an existing, Changelog.

![Generated release pr](<%= imagekit_url 'posts/automating-ruby-gem-releases-with-github-actions/generated-release-pr.png', :medium %>)

## Publish to RubyGems

Our current setup is great if we just want to automate changelog creation and versioning, but we would still have to publish the gem ourselves after the release was created. Fortunately, we can hook into our existing workflow to automate publishing as well!

You may have noticed we gave our first step an id of `release`. By doing this, we can check the output of that step in other steps and act accordingly.

Rather than juggle a long-lived RubyGems API token, we'll publish with [Trusted Publishing](https://guides.rubygems.org/trusted-publishing/). It uses OpenID Connect (OIDC) so GitHub Actions authenticates to RubyGems.org with a short-lived token minted at publish time — there's no secret to create, rotate, or leak. The [`rubygems/release-gem`](https://github.com/rubygems/release-gem) action handles the build-and-push for us.

### One-time RubyGems setup

Trusted publishing needs a one-time configuration on RubyGems.org. From the gem's **Trusted publishers** page, click **Create** and provide the repository owner, repository name, and the workflow filename (`release.yml`). For a gem that hasn't been published yet, add a [pending trusted publisher](https://guides.rubygems.org/trusted-publishing/) from your profile instead — the first successful publish claims the name. There's no secret to add to GitHub afterward.

### Setup Steps

`release-gem` assumes your workflow has already checked out the repo and set up Ruby with Bundler, and that your gem has Bundler's release tasks configured (the default `Rakefile` from `bundler gem` does). Guarded on `release_created`, we check out the code and set up Ruby. Per [the action's README](https://github.com/rubygems/release-gem/blob/v1/README.md), the checkout uses `persist-credentials: false`:

```yaml
      # Checkout code if release was created
      - uses: actions/checkout@v7
        with:
          persist-credentials: false
        if: ${{ steps.release.outputs.release_created }}
      # Setup ruby if a release was created
      - uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
          ruby-version: ruby
        if: ${{ steps.release.outputs.release_created }}
```

### Publish Step

If a release was created, `release-gem` builds the gem and pushes it to RubyGems over trusted publishing:

```yaml
- uses: rubygems/release-gem@v1
  if: ${{ steps.release.outputs.release_created }}
```

For this to work the job needs two permissions: `id-token: write` (mandatory for trusted publishing) and `contents: write` (so the release tasks can push the tag). As of `v1.1.0`, `release-gem` also generates a build provenance [attestation](https://github.com/rubygems/release-gem#attestations) by default.

## Release and Publish

Our final action, with the added `id-token: write` permission:

```yaml
# .github/workflows/release.yml

name: release

on:
  push:
    branches:
      - main

permissions:
  contents: write
  pull-requests: write
  id-token: write

jobs:
  release-please:
    runs-on: ubuntu-latest
    steps:
      - uses: googleapis/release-please-action@v4
        id: release
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
      # Checkout code if release was created
      - uses: actions/checkout@v7
        with:
          persist-credentials: false
        if: ${{ steps.release.outputs.release_created }}
      # Setup ruby if a release was created
      - uses: ruby/setup-ruby@v1
        with:
          bundler-cache: true
          ruby-version: ruby
        if: ${{ steps.release.outputs.release_created }}
      # Build and push to RubyGems via trusted publishing
      - uses: rubygems/release-gem@v1
        if: ${{ steps.release.outputs.release_created }}
```

Commit, push this code, and wait for your release PR to be updated by our action bot. Once the release PR has been updated, merge the PR into your main branch.

![Release action success](<%= imagekit_url 'posts/automating-ruby-gem-releases-with-github-actions/release-action-success.png' %>)

Once our release action runs, assuming it succeeds, you should see a new release in GitHub! One great feature of this action is that it will build the release notes from our changelog entries. 🚀

![New GitHub Release](<%= imagekit_url 'posts/automating-ruby-gem-releases-with-github-actions/new-github-release.png', :medium %>)

If we check RubyGems, we should see our new gem has been published and is ready to share!

![RubyGems](<%= imagekit_url 'posts/automating-ruby-gem-releases-with-github-actions/rubygems.png' %>)

## Final Thoughts

If you followed the tutorial and don't intend to use your new gem, you should consider yanking it to allow others to use the name in the future.

```bash
gem yank release-please-demo -v 1.0.0
```

One great aspect of the action is that you can use it with other languages or a `.txt` file, allowing you to create consistent pattern across all of your open source. You could enhance the workflow by adding in checks to run the tests before releases and also adding a linter to ensure conventional commits are used. With this workflow, you'll be able to make new releases without pulling down the code and never have to try and remember how you release a project again.

Give it a try and tell me what you think!
