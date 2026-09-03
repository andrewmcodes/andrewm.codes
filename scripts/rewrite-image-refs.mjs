// Point every post image reference at ImageKit, using scripts/imagekit-map.json.
//
// Three reference shapes get rewritten:
//   cloudinary_url 'v123/posts/…'  ->  imagekit_url 'posts/…'
//   cid: "v123/posts/…"            ->  iid: "posts/…"
//   https://<cloudinary|dev.to>/…  ->  <%= imagekit_url 'posts/…' %>
//
// Bare URLs become helper calls rather than absolute URLs so the endpoint stays
// in bridgetown.config.yml — one place to change if the account ever moves.
//
// The `:medium` preset (w-800) is applied only to images wider than 800px.
// ImageKit upscales on request, so asking a 622px screenshot for w-800 would
// enlarge and soften it.
//
// Idempotent: once rewritten there are no Cloudinary or dev.to references left
// to match, so a re-run is a no-op.
//
// Usage:
//   node scripts/rewrite-image-refs.mjs --dry-run
//   node scripts/rewrite-image-refs.mjs

import { readFile, writeFile } from "node:fs/promises";
import path from "node:path";
import { scanImageRefs, MAP_PATH, ROOT } from "./lib/image-refs.mjs";

const PRESET_MIN_WIDTH = 800;
const dryRun = process.argv.includes("--dry-run");

const escape = (value) => value.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");

let map;
try {
  map = JSON.parse(await readFile(MAP_PATH, "utf8"));
} catch {
  console.error(`Missing ${MAP_PATH}. Run migrate-images-to-imagekit.mjs first.`);
  process.exit(1);
}

const refs = await scanImageRefs();
if (refs.length === 0) {
  console.log("No Cloudinary or dev.to references left — nothing to rewrite.");
  process.exit(0);
}

// `imagekit_url 'posts/x.png', :medium` — the argument list, minus the helper
// name, so it can be dropped into ERB or an existing helper call.
function helperArgs(entry) {
  const bare = entry.filePath.replace(/^\//, "");
  const preset = entry.width && entry.width > PRESET_MIN_WIDTH ? ", :medium" : "";
  return `'${bare}'${preset}`;
}

const missing = [];
const edits = new Map(); // file -> [{ pattern, replacement }]

for (const ref of refs) {
  const entry = map[ref.sourceUrl];
  if (!entry) {
    missing.push(ref.sourceUrl);
    continue;
  }
  const args = helperArgs(entry);
  const bare = entry.filePath.replace(/^\//, "");
  const list = edits.get(ref.file) ?? [];

  if (ref.kind === "cloudinary_id") {
    // Two carriers for a public ID: the ERB helper call and the component's
    // `cid:`. Each takes the whole call so the preset argument goes with it.
    list.push({
      pattern: new RegExp(`cloudinary_url\\s+'${escape(ref.token)}'(\\s*,\\s*:\\w+)?`, "g"),
      replacement: `imagekit_url ${args}`,
    });
    list.push({
      pattern: new RegExp(`cid:\\s*"${escape(ref.token)}"`, "g"),
      replacement: `iid: "${bare}"`,
    });
  } else {
    list.push({
      pattern: new RegExp(escape(ref.token), "g"),
      replacement: `<%= imagekit_url ${args} %>`,
    });
  }
  edits.set(ref.file, list);
}

if (missing.length) {
  console.error(`${missing.length} reference(s) missing from the map — re-run the upload:`);
  for (const url of missing) console.error(`  ${url}`);
  process.exit(1);
}

let total = 0;
for (const [relative, list] of [...edits].sort()) {
  const file = path.join(ROOT, relative);
  const before = await readFile(file, "utf8");
  let text = before;
  let count = 0;

  for (const { pattern, replacement } of list) {
    text = text.replace(pattern, () => {
      count += 1;
      return replacement;
    });
  }

  if (text === before) {
    console.log(`--   ${relative} (no change)`);
    continue;
  }
  console.log(`${dryRun ? "DRY " : "OK  "} ${relative} (${count} replacements)`);
  total += count;
  if (!dryRun) await writeFile(file, text);
}

console.log(dryRun ? `\nDry run — ${total} replacements, no files written.` : `\nDone — ${total} replacements.`);
