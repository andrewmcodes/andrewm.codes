# andrewm.codes

[![Lint](https://github.com/andrewmcodes/website-v6/actions/workflows/lint.yml/badge.svg)](https://github.com/andrewmcodes/website-v6/actions/workflows/lint.yml)
[![Test](https://github.com/andrewmcodes/website-v6/actions/workflows/tests.yml/badge.svg)](https://github.com/andrewmcodes/website-v6/actions/workflows/tests.yml)
[![release-please](https://github.com/andrewmcodes/website-v6/actions/workflows/release.yml/badge.svg)](https://github.com/andrewmcodes/website-v6/actions/workflows/release.yml)

[![Ruby Style Guide](https://img.shields.io/badge/ruby_code_style-standard-orange.svg)](https://github.com/testdouble/standard)
[![JavaScript Style Guide](https://img.shields.io/badge/js_code_style-prettier-ff69b4.svg?style=flat-square)](https://prettier.io)
[![CSS Style Guide](https://img.shields.io/badge/css_code_style-stylelint-black.svg?style=flat-square)](https://prettier.io)
[![Conventional Commits](https://img.shields.io/badge/Conventional%20Commits-1.0.0-yellow.svg)](https://conventionalcommits.org/)

---

## Developing in Codespaces

This project comes with a [`.devcontainer.json` configuration](https://docs.github.com/en/codespaces/setting-up-your-project-for-codespaces/introduction-to-dev-containers) so the quickest way to get up and running is with [GitHub Codespaces](https://github.com/features/codespaces) for the majority of changes.

## Developing Locally

### Prerequisites

- Ruby
- NodeJS
- Yarn
- Bundler

An exhaustive list can be found [here](https://www.bridgetownrb.com/docs/installation) if you run into issues, but you likely already have these dependencies installed (maybe not the right versions though) if you are working on Rails applications.

The project is set up to run everything through binstubs but you may want to install the Bridgetown gem yourself:

`gem install bridgetown`

### Install

```sh
cd andrewm.codes
bundle install && yarn install
```

> Learn more: [Bridgetown Getting Started Documentation](https://www.bridgetownrb.com/docs/).

---

## Development

To start your site in development mode, run `bin/bridgetown start` and navigate to [localhost:4000](https://localhost:4000/)!

If you have never used the Bridgetown CLI before, `bin/bridgetown start` is the most important one to know, and the rest can be found here: [Bridgetown CLI Documentation](https://www.bridgetownrb.com/docs/command-line-usage)

## Deployment

This site is deployed with and hosted on Vercel.

PR's have deploy previews automatically generated and merging to main will deploy the site to production.

## Contributing

1. Fork it
2. Open in Codespaces or clone the fork using `git clone` or `gh repo clone` to your local development machine.
3. Create your feature branch (`git checkout -b feat-add-webmentions`)
4. Commit your changes using [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) messages. For a list of allowed prefixes, [check here.](https://github.com/conventional-changelog/commitlint/tree/master/%40commitlint/config-conventional#type-enum) (`git commit -am 'feat: Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request on GitHub and fill in the PR template provided
