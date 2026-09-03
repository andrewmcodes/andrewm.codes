// Shared scanner for externally-hosted images referenced from src/.
//
// Both the upload script and the rewrite script read the tree through this
// module, so they can never disagree about which references exist or what an
// asset is called once it lands in ImageKit.
//
// Four reference shapes cover every hit in the repo:
//
//   A  ![alt](https://…)                                   markdown inline
//   B  [label]: https://…                                  markdown reference definition
//   C  <img alt="…" src="<%= cloudinary_url 'id', :p %>">  ERB helper inside markdown
//   D  Image.new(…, cid: "id", alt: "…")                   component render
//
// Shapes C and D carry a Cloudinary public ID rather than a URL, so each ref
// records both `sourceUrl` (absolute, what ImageKit fetches) and `token` (the
// exact substring to replace in source).

import { readFile, readdir } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import path from "node:path";

export const ROOT = fileURLToPath(new URL("../..", import.meta.url));
export const MAP_PATH = fileURLToPath(new URL("../imagekit-map.json", import.meta.url));

const CLOUDINARY_BASE = "https://res.cloudinary.com/andrewmcodes/image/upload";
const DEVTO_PREFIX = "https://dev-to-uploads.s3.amazonaws.com/";

// Only these are treated as real extensions. Several Cloudinary public IDs end
// in something that merely looks like one — `…/20220505050712Z_BlackMagic.so2`
// is a filename about the site BlackMagic.so, not a `.so2` file.
const EXTENSIONS = [".png", ".jpg", ".jpeg", ".gif", ".webp", ".avif", ".svg"];

// Alt text that names nothing. Falling back to the source basename beats
// minting `alt-text-2.jpg`, and flags the underlying copy as worth fixing.
const USELESS_LABELS = new Set(["", "alt text", "image", "img", "screenshot"]);

export function slugify(value) {
  return String(value)
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

export function splitExtension(name) {
  const lower = name.toLowerCase();
  const ext = EXTENSIONS.find((candidate) => lower.endsWith(candidate));
  return ext ? { stem: name.slice(0, -ext.length), ext } : { stem: name, ext: "" };
}

async function sourceFiles() {
  const found = [];
  async function walk(dir) {
    for (const entry of await readdir(dir, { withFileTypes: true })) {
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) await walk(full);
      else found.push(full);
    }
  }
  await walk(path.join(ROOT, "src"));
  return found.sort();
}

// A post's slug is its filename, regardless of which _posts subdirectory it
// lives in — that is also the last segment of its published /p/<slug>/ URL.
function postSlug(relativePath) {
  return path.basename(relativePath).replace(/\.[^.]+$/, "");
}

function collect(text, relative) {
  const refs = [];
  const push = (token, sourceUrl, label, kind) =>
    refs.push({ file: relative, post: postSlug(relative), token, sourceUrl, label, kind });

  // A — markdown inline images on either host.
  for (const [, alt, url] of text.matchAll(
    /!\[([^\]]*)\]\((https:\/\/(?:dev-to-uploads\.s3\.amazonaws\.com|res\.cloudinary\.com)\/[^)\s]+)\)/g
  )) {
    push(url, url, alt, "url");
  }

  // B — markdown reference definitions; the label is the best name available.
  for (const [, label, url] of text.matchAll(
    /^\[([^\]]+)\]:\s*(https:\/\/(?:dev-to-uploads\.s3\.amazonaws\.com|res\.cloudinary\.com)\/\S+)\s*$/gm
  )) {
    push(url, url, label, "url");
  }

  // C — ERB helper call inside an <img> tag; alt sits before the src.
  for (const [, alt, publicId] of text.matchAll(
    /<img\s+alt="([^"]*)"\s+src="<%=\s*cloudinary_url\s+'([^']+)'/g
  )) {
    push(publicId, `${CLOUDINARY_BASE}/${publicId}`, alt, "cloudinary_id");
  }

  // D — Image component render.
  for (const [, publicId, alt] of text.matchAll(/cid:\s*"([^"]+)"[^)]*?alt:\s*"([^"]*)"/g)) {
    push(publicId, `${CLOUDINARY_BASE}/${publicId}`, alt, "cloudinary_id");
  }

  return refs;
}

// Turns a label into `posts/<post>/<name>.<ext>`, deduplicating within a post
// so two images that share alt text ("GitHub Pages Public URL" appears twice)
// still get distinct paths.
function assignTargets(refs) {
  const used = new Map();

  return refs.map((ref) => {
    const basename = decodeURIComponent(ref.sourceUrl.split("/").pop());
    const { stem, ext } = splitExtension(basename);
    const label = ref.label.trim().toLowerCase();
    const name = USELESS_LABELS.has(label) ? slugify(stem) : slugify(ref.label);
    const folder = `posts/${ref.post}`;

    let candidate = `${name}${ext}`;
    const seen = used.get(`${folder}/${candidate}`);
    if (seen !== undefined) {
      const next = seen + 1;
      used.set(`${folder}/${candidate}`, next);
      candidate = `${name}-${next}${ext}`;
    }
    used.set(`${folder}/${candidate}`, used.get(`${folder}/${candidate}`) ?? 1);

    return { ...ref, folder, fileName: candidate };
  });
}

// Every external image reference in src/, deduplicated by source URL. A URL
// used twice uploads once; both call sites rewrite to the same path.
export async function scanImageRefs() {
  const refs = [];
  for (const file of await sourceFiles()) {
    const relative = path.relative(ROOT, file);
    let text;
    try {
      text = await readFile(file, "utf8");
    } catch {
      continue; // binary or unreadable — no references either way
    }
    // `cloudinary_url` matters on its own: the two posts that call the helper
    // carry no literal URL anywhere in the file.
    const interesting = ["res.cloudinary.com", DEVTO_PREFIX, "cloudinary_url", "cid:"];
    if (!interesting.some((needle) => text.includes(needle))) continue;
    refs.push(...collect(text, relative));
  }

  const byUrl = new Map();
  for (const ref of assignTargets(refs)) {
    const existing = byUrl.get(ref.sourceUrl);
    if (existing) existing.tokens.add(ref.token);
    else byUrl.set(ref.sourceUrl, { ...ref, tokens: new Set([ref.token]) });
  }
  return [...byUrl.values()];
}
