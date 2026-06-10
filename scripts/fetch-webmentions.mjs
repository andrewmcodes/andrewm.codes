// Fetches webmentions for the site from webmention.io and writes them to
// src/_data/webmentions.json (a JF2 feed). Bridgetown exposes the result as
// `site.data.webmentions`; the Webmentions component filters it per post.
//
// Auth: webmention.io's per-domain feed requires the account API token. Set
// WEBMENTION_IO_TOKEN (Keychain via fnox locally; repo secret in CI). When the
// token is absent the script logs and exits 0 WITHOUT touching the committed
// file, so builds never break on a missing secret.
//
// Run: `mise run webmentions` (fnox-wrapped) or `node scripts/fetch-webmentions.mjs`.

import { writeFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { dirname, resolve } from "node:path";

const DOMAIN = "andrewm.codes";
const PER_PAGE = 200;
const OUT = resolve(dirname(fileURLToPath(import.meta.url)), "../src/_data/webmentions.json");

const token = process.env.WEBMENTION_IO_TOKEN;
if (!token) {
  console.warn("WEBMENTION_IO_TOKEN not set — skipping fetch, leaving src/_data/webmentions.json unchanged.");
  process.exit(0);
}

// Page through the JF2 feed until a short page signals the end.
async function fetchAll() {
  const children = [];
  for (let page = 0; ; page++) {
    const url = new URL("https://webmention.io/api/mentions.jf2");
    url.searchParams.set("domain", DOMAIN);
    url.searchParams.set("token", token);
    url.searchParams.set("per-page", String(PER_PAGE));
    url.searchParams.set("page", String(page));

    const res = await fetch(url);
    if (!res.ok) {
      throw new Error(`webmention.io responded ${res.status} ${res.statusText}`);
    }
    const feed = await res.json();
    const batch = feed.children ?? [];
    children.push(...batch);
    if (batch.length < PER_PAGE) break;
  }
  return children;
}

const children = await fetchAll();
// Newest first so the component can take the most recent without re-sorting.
children.sort((a, b) => (b["wm-received"] ?? "").localeCompare(a["wm-received"] ?? ""));

const feed = { type: "feed", name: "Webmentions", children };
await writeFile(OUT, JSON.stringify(feed, null, 2) + "\n");
console.log(`Wrote ${children.length} webmentions to ${OUT}`);
