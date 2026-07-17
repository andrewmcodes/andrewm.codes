# Runbooks

Operational procedures for the andrewm.codes site. Each section covers the minimum required steps; deeper context lives in `AGENTS.md`.

## Rotate `TORCHLIGHT_TOKEN`

The Torchlight API token authenticates the production syntax highlighter (`plugins/builders/torchlight.rb`). If the production build job fails with HTTP 401/403 from Torchlight, rotate the token.

1. Generate a new token at <https://torchlight.dev>.
2. Update the GitHub Actions secret:
   ```sh
   gh secret set TORCHLIGHT_TOKEN --body "<new-token>"
   ```
3. Update the local `fnox` store so manual `mise run build` keeps working:
   ```sh
   fnox set TORCHLIGHT_TOKEN <new-token>
   ```
4. Re-run the failed CI job to confirm.

## Rotate `BUZZSPROUT_API_TOKEN`

Used by `.github/workflows/sync-remote-ruby.yml` to refresh `src/_data/remote_ruby.json` from the Buzzsprout API.

1. Issue a new token from the Buzzsprout dashboard (Account → API).
2. `gh secret set BUZZSPROUT_API_TOKEN --body "<new-token>"`.
3. Trigger the workflow manually to verify:
   ```sh
   gh workflow run "Sync latest Remote Ruby episode"
   ```

## Bypass OG image generation

If `scripts/generate-og.mjs` fails (Satori upgrade regression, missing fonts, API change) and you need to ship a fix without blocking on OG, you have two escape hatches:

- **Temporary, in CI:** comment out the `site:post_write` hook block in `plugins/builders/og_images.rb` (the `if Bridgetown.env.production?` branch). Existing PNGs under `output/og/` from the previous deploy keep serving from Cloudflare's cache; new posts fall back to whatever `og:image` URL is in their meta (currently `/og/<slug>.png`, which will 404 until you re-enable generation).
- **Locally:** `BRIDGETOWN_ENV=development bin/bridgetown deploy` skips OG generation entirely. Useful for diffing other build changes without paying the OG time cost.

After fixing the underlying issue, regenerate the full set locally with `mise run og` and verify a sample image before pushing.

## Recover from a bad data-sync commit

`.github/workflows/sync-oss.yml` and `sync-remote-ruby.yml` commit directly to `main` on cron. If an upstream API change writes malformed JSON, the next deploy will fail (or worse, ship blank data).

1. Identify the bad commit:
   ```sh
   git log --author="andrewmcodes-bot" -- src/_data/oss.json src/_data/remote_ruby.json
   ```
2. Revert just the data file from the previous known-good commit:
   ```sh
   git checkout <good-sha> -- src/_data/oss.json
   git commit -m "revert(data): roll back malformed OSS sync"
   git push
   ```
3. Open an issue on the workflow file to add validation before re-enabling.

## Restore `fnox` on a new machine

`fnox` decrypts `fnox.toml` (committed) with an age key (not committed) at `~/.config/fnox/age.txt`. Without that key, `mise run build` cannot read `TORCHLIGHT_TOKEN`.

1. From the source machine, copy the age key:
   ```sh
   scp ~/.config/fnox/age.txt new-host:~/.config/fnox/age.txt
   chmod 600 ~/.config/fnox/age.txt
   ```
2. On the new machine, verify decryption:
   ```sh
   fnox exec -- env | grep TORCHLIGHT_TOKEN
   ```
3. If the source machine is gone and the key is lost, generate a new age identity and re-encrypt `fnox.toml` against it; you'll need to re-add every secret from its source-of-truth (Torchlight dashboard, Buzzsprout, etc.).

## Roll back a Cloudflare deploy

The CI deploy job runs `wrangler deploy` on push to `main`. To revert:

1. `git revert <bad-sha>` and push — the next CI run will redeploy the prior state.
2. Or use Cloudflare's dashboard rollback (Workers → andrewm-codes → Deployments → Rollback). This is faster but doesn't update git, so the next push from main will reintroduce the issue.

## Force a fresh production build

If you suspect cached output (`.bridgetown-cache/`, `.torchlight-cache/`):

```sh
rm -rf .bridgetown-cache .torchlight-cache output
mise run build
```

Torchlight will re-hit the API on every snippet (slower), so only do this when you have an actual cache-correctness concern.
