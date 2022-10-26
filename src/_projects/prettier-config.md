---
title: "@andrewmcodes/prettier-config"
description: My personal Prettier configuration
tags:
  - prettier
  - npm
repo: andrewmcodes/prettier-config
last_modified_at: 2022-06-03T04:55:52.000Z
status: active
type: project
npm:
  url: https://www.npmjs.com/package/@andrewmcodes/prettier-config
  label: "@andrewmcodes/prettier-config"
---

## Install

```sh
yarn add -D @andrewmcodes/prettier-config
```

## Usage

Add the following to your `package.json`:

```json
{
  "prettier": "@andrewmcodes/prettier-config"
}
```

or add the following to your `.prettierrc`:

```json
"@andrewmcodes/prettier-config"
```

## Overrides

```js
# .prettierrc.js

module.exports = {
  ...require("@andrewmcodes/prettier-config"),
  singleQuote: true,
};
```
