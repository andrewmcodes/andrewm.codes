# andrewm.codes

Personal site built with [Bridgetown](https://www.bridgetownrb.com), styled
with Tailwind v4 and [Radix UI Colors](https://www.radix-ui.com/colors)
(Sage + Mint). Syntax highlighting via Bridgetown's built-in Rouge.

## Develop

```bash
mise run setup
mise run dev
```

`mise install` runs implicitly via `mise run setup` if tools aren't present.

The design-system conventions live in [docs/design-system.md](docs/design-system.md).

## Secrets (fnox)

API keys and other secrets are managed with [fnox](https://github.com/jdx/fnox), installed via mise. This repo uses fnox's **macOS Keychain** provider: the committed `fnox.toml` is plaintext and only declares which env vars to populate and the Keychain entry name to read from (all under the `fnox-andrewmcodes-v8` service). Secret _values_ live in your Keychain — never in git.

First-time setup on a new Mac:

```bash
# Install tools (includes fnox)
mise install

# Write each value into the macOS Keychain via fnox.
# fnox.toml already declares the names; this just stores the values.
fnox set CLOUDFLARE_API_KEY        # from https://dash.cloudflare.com/profile/api-tokens
fnox set CLOUDFLARE_EMAIL
fnox set BUZZSPROUT_API_TOKEN      # from Buzzsprout dashboard

# Optional: turn on shell integration so secrets auto-load when you cd here
eval "$(fnox activate zsh)"   # or bash / fish
```

After this, `mise run build` wraps the production build in `fnox exec` so
configured secrets are in scope for build/deploy tasks.

Moving to a second machine just means re-running the `fnox set` commands there — there's no key material to copy.

## Deploy

The site is deployed to **Cloudflare Workers Static Assets** (see `wrangler.jsonc`) via the `cloudflare/wrangler-action@v4` GitHub Action.

- Push to `main` → CI builds and runs `wrangler deploy` to production.
- PR from a same-repo branch → CI uploads a preview version with a `pr-<num>-<branch>` alias and posts the preview URL as a PR comment.
- Fork PRs skip the deploy job (no secret access); lint/test/build still run.

GitHub Actions CI uses these repo secrets:

- `CLOUDFLARE_API_TOKEN` (Workers Scripts: Edit permission) — wrangler deploy.
- `CLOUDFLARE_ACCOUNT_ID` — wrangler deploy target.
- `BUZZSPROUT_API_TOKEN` — daily `sync-remote-ruby` workflow that refreshes `src/_data/remote_ruby.json` from the [Buzzsprout API](https://github.com/Buzzsprout/buzzsprout-api).

## License

MIT — see LICENSE.md
