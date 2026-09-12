// @ts-check
// Upload a new post's staged images to ImageKit and print paste-ready refs.
//
// Drop a post's images in tmp/post-images/<slug>/, then run:
//   mise run upload-images <slug>              # upload
//   mise run upload-images <slug> -- --dry-run # preview, no network
//
// Each file lands at ImageKit path posts/<slug>/<name>.<ext> and the script
// prints a `![alt](<%= imagekit_url '…' %>)` line to paste into the post.
// Uploads are idempotent: useUniqueFileName off + overwriteFile on, so a
// re-run replaces rather than duplicates.

import { readFile, readdir } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import path from "node:path";

const UPLOAD_URL = "https://upload.imagekit.io/api/v1/files/upload";
const CONCURRENCY = 4;
const PRESET_MIN_WIDTH = 800;
const EXTENSIONS = new Set([".png", ".jpg", ".jpeg", ".gif", ".webp", ".avif", ".svg"]);

/**
 * @typedef {Object} Result
 * @property {string} name
 * @property {string} fileName
 * @property {string} stem
 * @property {number|null} width
 */

const ROOT = fileURLToPath(new URL("..", import.meta.url));

const args = process.argv.slice(2);
const dryRun = args.includes("--dry-run");
const slug = args.find((arg) => !arg.startsWith("-"));

if (!slug) {
  console.error("Usage: node scripts/upload-post-images.mjs <slug> [--dry-run]");
  process.exit(1);
}

const stagingDir = path.join(ROOT, "tmp", "post-images", slug);

const privateKey = process.env.IMAGEKIT_PRIVATE_KEY;
if (!privateKey && !dryRun) {
  console.error("Set IMAGEKIT_PRIVATE_KEY (or pass --dry-run). Run via `mise run upload-images` so fnox exports it.");
  process.exit(1);
}

// ImageKit uses HTTP Basic auth: private key as the username, empty password.
const auth = "Basic " + Buffer.from(`${privateKey}:`).toString("base64");

/** @param {string} value */
function slugify(value) {
  return String(value)
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

/** @param {string} stem */
function titleize(stem) {
  return stem
    .split("-")
    .filter(Boolean)
    .map((word) => word[0].toUpperCase() + word.slice(1))
    .join(" ");
}

/** @param {string} name */
function splitExtension(name) {
  const ext = path.extname(name).toLowerCase();
  return EXTENSIONS.has(ext) ? { stem: name.slice(0, -ext.length), ext } : { stem: name, ext: "" };
}

async function readImages() {
  let entries;
  try {
    entries = await readdir(stagingDir, { withFileTypes: true });
  } catch {
    console.error(
      `No staging folder at ${path.relative(ROOT, stagingDir)}/ — create it and drop this post's images there.`,
    );
    process.exit(1);
  }

  const images = entries
    .filter((entry) => entry.isFile() && EXTENSIONS.has(path.extname(entry.name).toLowerCase()))
    .map((entry) => entry.name)
    .sort();

  if (images.length === 0) {
    console.error(`No images in ${path.relative(ROOT, stagingDir)}/ — expected ${[...EXTENSIONS].join(", ")}.`);
    process.exit(1);
  }
  return images;
}

/**
 * @param {{ fileBytes: Uint8Array, folder: string, fileName: string }} params
 */
async function upload({ fileBytes, folder, fileName }) {
  const form = new FormData();
  form.append("file", new Blob([/** @type {BlobPart} */ (fileBytes)]), fileName);
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

/** @param {Result} result */
function reference({ fileName, stem, width }) {
  const preset = width && width > PRESET_MIN_WIDTH ? ", :medium" : "";
  return `![${titleize(slugify(stem))}](<%= imagekit_url 'posts/${slug}/${fileName}'${preset} %>)`;
}

const images = await readImages();
console.log(`${images.length} image(s) in ${path.relative(ROOT, stagingDir)}/\n`);

/** @type {Result[]} */
const results = [];
let failures = 0;

/** @param {string} name */
async function handle(name) {
  const { stem, ext } = splitExtension(name);
  const fileName = `${slugify(stem)}${ext}`;

  if (dryRun) {
    console.log(`DRY  ${name}\n  -> posts/${slug}/${fileName}`);
    results.push({ name, fileName, stem, width: null });
    return;
  }

  try {
    const fileBytes = await readFile(path.join(stagingDir, name));
    const { filePath, width, height } = await upload({ fileBytes, folder: `posts/${slug}`, fileName });
    console.log(`OK   ${filePath} (${width}x${height})`);
    results.push({ name, fileName, stem, width });
  } catch (error) {
    console.error(`FAIL ${name}\n  -> ${error instanceof Error ? error.message : String(error)}`);
    failures += 1;
  }
}

const queue = [...images];
await Promise.all(
  Array.from({ length: Math.min(CONCURRENCY, queue.length) }, async () => {
    let name;
    while ((name = queue.shift())) await handle(name);
  }),
);

const ordered = images
  .map((name) => results.find((result) => result.name === name))
  .filter((result) => result !== undefined);

if (ordered.length) {
  console.log(`\n--- paste into src/_posts/…/${slug}.md ---\n`);
  for (const result of ordered) console.log(reference(result));
}

if (failures) {
  console.error(`\n${failures} upload(s) failed.`);
  process.exit(1);
}
