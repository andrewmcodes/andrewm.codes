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

## Website improvement scorecard (quarterly)

Track these KPIs before and after major changes so improvements are measurable:

- Lighthouse scores on: `/`, `/posts/`, `/about/`, `/projects/`, `/speaking/`, `/p/kill-process-on-port/`, `/tag/rails/`.
- Search visibility: indexed pages, impressions, clicks, and CTR in Search Console.
- Engagement: top landing pages, pages/session, and exits on hub pages (`/posts/`, `/projects/`, `/speaking/`).
- Outcomes: speaking/contact inbound (Bluesky DMs + referral patterns in analytics).

Cadence:

1. Capture a baseline snapshot before making structural/content changes.
2. Re-capture one week after deploy and again after 30 days.
3. Log notable changes and outcomes in `CHANGELOG.md` under the related release.

## Content quality checklist (for new/updated pages)

Use this checklist before publishing:

1. **SEO**: unique title + meta description, canonical correct, OG/Twitter card present.
2. **Accessibility**: single H1, heading order logical, links have clear text, keyboard navigation works.
3. **Internal links**: include at least 2 contextual links to related posts/projects/speaking pages.
4. **Structured data**: page emits valid JSON-LD for its type (article/listing/profile/etc.).
5. **Freshness**: add/update `last_modified_at` when meaningfully revising older content.

## Data sync validation before deploy

Scheduled sync workflows already validate API payload shape. CI now also runs `bundle exec rake data:validate` to prevent malformed `_data` files from reaching production.

If this check fails:

1. Inspect the changed file in `src/_data/`.
2. Confirm required keys exist (`remote_ruby.json`: `id`, `title`, `url`, `published_at`; `oss.json`: non-empty array with `name` + `url`).
3. Re-run the sync job after fixing parser/shape assumptions.

## Content ownership cadence

- **Weekly**: review homepage "now" section and latest episode/talk pointers.
- **Monthly**: review `/projects/` featured cards + `src/_data/featured.yml`.
- **Quarterly**: prune stale tags/topics and refresh top posts with meaningful edits + `last_modified_at`.
- **Per release**: ensure About/Speaking/Uses still match current stack and priorities.

## Security hygiene cadence

- Monthly: review dependency updates and security alerts.
- Quarterly: review `_headers` policy set (CSP, HSTS, permissions policy) and tighten where safe.
- Before each release: confirm noindex pages remain limited to intended routes (`/search/`, `/404.html`, thin `/tag/*` pages).
