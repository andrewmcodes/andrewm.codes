# Changelog

## [Unreleased]

## [0.6.2] - 2025-11-03

- Rename proc internals to `__streamlined` prefix to avoid pollution
- Convert tests to spec style & remove rails-dom-testing

## [0.6.1] - 2025-09-07

- Migrate repo to Codeberg

## [0.6.0] - 2024-09-07

- Use much faster `CGI.escapeHTML` for escaping text

## [0.5.2] - 2024-04-06

- And we need that same fix for `text` too

## [0.5.1] - 2024-04-06

- Fix logic bug in `html`

## [0.5.0] - 2024-04-06

- Simplify syntax of pipe procs for `text` & `html`

## [0.4.0] — 2024-04-04

- Provide Roda plugin to mix in Streamlined helpers.

## [0.3.1] - 2023-11-10

- Ensure false or nil values for attributes avoid rendering attributes at all

## [0.3.0] - 2023-11-07

- Fix escaping bug due to bad test

## [0.2.0] - 2023-11-07

- Back out of more complicated `render_in` mechanics

## [0.1.0] - 2023-11-04

- Extraction from Bridgetown & Lifeform to serve as a standalone gem.
