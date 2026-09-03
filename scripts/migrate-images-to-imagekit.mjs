// Move every externally-hosted post image (Cloudinary + dev.to) to ImageKit.
//
// ImageKit's Upload API accepts a remote URL as the `file` field, so this
// points it at each current URL and lets ImageKit fetch and store the bytes —
// nothing is downloaded locally. Uploads are idempotent: `useUniqueFileName`
// is off and `overwriteFile` is on, so a re-run replaces rather than
// duplicates.
//
// Usage:
//   node scripts/migrate-images-to-imagekit.mjs --dry-run
//   IMAGEKIT_PRIVATE_KEY=… node scripts/migrate-images-to-imagekit.mjs
//   fnox exec -- node scripts/migrate-images-to-imagekit.mjs
//
// Writes scripts/imagekit-map.json, which drives rewrite-image-refs.mjs. The
// recorded width/height come from ImageKit's response, so the rewrite can emit
// intrinsic dimensions and stop these images shifting the layout as they load.

import { writeFile } from "node:fs/promises";
import { scanImageRefs, MAP_PATH } from "./lib/image-refs.mjs";

const UPLOAD_URL = "https://upload.imagekit.io/api/v1/files/upload";
const CONCURRENCY = 4;

const dryRun = process.argv.includes("--dry-run");
const privateKey = process.env.IMAGEKIT_PRIVATE_KEY;

if (!privateKey && !dryRun) {
  console.error("Set IMAGEKIT_PRIVATE_KEY (or pass --dry-run).");
  process.exit(1);
}

// ImageKit uses HTTP Basic auth: private key as the username, empty password.
const auth = "Basic " + Buffer.from(`${privateKey}:`).toString("base64");

async function upload({ sourceUrl, folder, fileName }) {
  const form = new FormData();
  form.append("file", sourceUrl); // remote URL — ImageKit fetches it
  form.append("fileName", fileName);
  form.append("folder", folder);
  form.append("useUniqueFileName", "false");
  form.append("overwriteFile", "true");

  const response = await fetch(UPLOAD_URL, {
    method: "POST",
    headers: { Authorization: auth },
    body: form,
  });
  const body = await response.json();
  if (!response.ok) {
    throw new Error(`${response.status} ${body?.message ?? JSON.stringify(body)}`);
  }
  return { filePath: body.filePath, width: body.width, height: body.height };
}

const refs = await scanImageRefs();
console.log(`${refs.length} external image references found.\n`);

const map = {};
let failures = 0;

async function handle(ref) {
  const target = `/${ref.folder}/${ref.fileName}`;
  if (dryRun) {
    console.log(`DRY  ${ref.sourceUrl}\n  -> ${target}`);
    map[ref.sourceUrl] = { token: ref.token, filePath: target, width: null, height: null };
    return;
  }
  try {
    const { filePath, width, height } = await upload(ref);
    map[ref.sourceUrl] = { token: ref.token, filePath, width, height };
    console.log(`OK   ${filePath} (${width}x${height})`);
  } catch (error) {
    console.error(`FAIL ${ref.sourceUrl}\n  -> ${error.message}`);
    failures += 1;
  }
}

// A small pool: ImageKit fetches each source itself, so these are slow calls,
// but hammering the upload endpoint with 47 at once invites rate limiting.
const queue = [...refs];
await Promise.all(
  Array.from({ length: Math.min(CONCURRENCY, queue.length) }, async () => {
    let ref;
    while ((ref = queue.shift())) await handle(ref);
  })
);

// Stable key order keeps the committed map reviewable across re-runs.
const sorted = Object.fromEntries(Object.keys(map).sort().map((key) => [key, map[key]]));
await writeFile(MAP_PATH, JSON.stringify(sorted, null, 2) + "\n");

console.log(`\nWrote ${MAP_PATH} (${Object.keys(sorted).length} entries).`);
if (failures) {
  console.error(`${failures} upload(s) failed — rerun before rewriting references.`);
  process.exitCode = 1;
}
