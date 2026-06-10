// @ts-check
import { readFileSync, writeFileSync, mkdirSync, readdirSync, existsSync, copyFileSync, statSync } from "node:fs"
import { join, relative, dirname, basename } from "node:path"
import { createHash } from "node:crypto"
import { parse } from "node-html-parser"
import satori from "satori"
import { Resvg } from "@resvg/resvg-js"

/**
 * @typedef {Object} Payload
 * @property {string} title
 * @property {string} description
 * @property {string} siteName
 */

/**
 * @typedef {Object} Meta
 * @property {string} [title]
 * @property {string} [description]
 * @property {string} [siteName]
 * @property {string} [imageUrl]
 */

const FONT_PATHS = {
  regular: "node_modules/@fontsource/inter/files/inter-latin-400-normal.woff",
  bold:    "node_modules/@fontsource/inter/files/inter-latin-700-normal.woff",
}

for (const [label, path] of Object.entries(FONT_PATHS)) {
  if (!existsSync(path)) {
    console.error(`OG: missing Inter ${label} font at ${path}. Did you run \`pnpm install\`?`)
    process.exit(1)
  }
}

/** @type {import("satori").SatoriOptions["fonts"]} */
const FONTS = [
  { name: "Inter", data: readFileSync(FONT_PATHS.regular), weight: 400, style: "normal" },
  { name: "Inter", data: readFileSync(FONT_PATHS.bold),    weight: 700, style: "normal" },
]

const SITE_ROOT = process.argv[2] || "output"
const TITLE_MAX = 100
const DESC_MAX  = 200

// Per-image content cache. Survives across builds (output/ is wiped on each
// `rake deploy`, but .bridgetown-cache/ is not). Skip re-rendering when the
// inputs hash to the same value as last time.
const CACHE_DIR = ".bridgetown-cache/og"
const MANIFEST_PATH = join(CACHE_DIR, "manifest.json")
const manifest = existsSync(MANIFEST_PATH)
  ? JSON.parse(readFileSync(MANIFEST_PATH, "utf8"))
  : {}

/** @param {Payload} p */
function payloadHash(p) {
  // Hash includes the rendering inputs AND the visual config so a template
  // change invalidates every cache entry without manual flushing.
  return createHash("sha256")
    .update(JSON.stringify({ p, OG }))
    .digest("hex")
    .slice(0, 16)
}

// Visual config for the OG template. Tweak here, not inline in the JSX-like
// tree below. Dimensions match the Twitter/Facebook large-image card.
const OG = {
  image:   { width: 1200, height: 630 },
  layout:  { padding: 80, gap: 32 },
  colors:  {
    background:  "#101211",
    foreground:  "#eceeed",
    siteName:    "#58d5ba",
    description: "#adb5b2",
  },
  siteName:    { fontSize: 24, fontWeight: 500, letterSpacing: 0.5 },
  title:       { fontSize: 64, fontWeight: 700, lineHeight: 1.1 },
  description: { fontSize: 28, fontWeight: 400, lineHeight: 1.35 },
}

/** @param {string | undefined} s @param {number} max @returns {string | undefined} */
function truncate(s, max) {
  if (!s) return s
  const cleaned = s.replace(/\s+/g, " ").trim()
  return cleaned.length > max ? cleaned.slice(0, max - 1).trimEnd() + "…" : cleaned
}

/** @param {Payload} payload */
function template(payload) {
  const { title, description, siteName } = payload
  return {
    type: "div",
    props: {
      style: {
        display: "flex", flexDirection: "column",
        width: "100%", height: "100%",
        background: OG.colors.background, color: OG.colors.foreground,
        padding: OG.layout.padding, fontFamily: "Inter",
      },
      children: [
        {
          type: "div",
          props: {
            style: { ...OG.siteName, color: OG.colors.siteName },
            children: siteName,
          },
        },
        {
          type: "div",
          props: {
            style: {
              display: "flex", flexDirection: "column",
              marginTop: "auto", gap: OG.layout.gap,
            },
            children: [
              {
                type: "div",
                props: {
                  style: OG.title,
                  children: truncate(title, TITLE_MAX),
                },
              },
              description && {
                type: "div",
                props: {
                  style: { ...OG.description, color: OG.colors.description },
                  children: truncate(description, DESC_MAX),
                },
              },
            ].filter(Boolean),
          },
        },
      ],
    },
  }
}

/** @param {Payload} payload @param {string} outPath @returns {Promise<number>} */
async function render(payload, outPath) {
  const key = basename(outPath)
  const hash = payloadHash(payload)
  const cachePath = join(CACHE_DIR, key)

  mkdirSync(dirname(outPath), { recursive: true })

  if (manifest[key] === hash && existsSync(cachePath)) {
    copyFileSync(cachePath, outPath)
    const bytes = statSync(cachePath).size
    console.log(`↪ ${relative(".", outPath)} (cache hit, ${bytes}B)`)
    return 0
  }

  const start = performance.now()
  const svg = await satori(template(payload), { width: OG.image.width, height: OG.image.height, fonts: FONTS })
  const png = new Resvg(svg, { background: OG.colors.background }).render().asPng()
  writeFileSync(outPath, png)
  mkdirSync(CACHE_DIR, { recursive: true })
  writeFileSync(cachePath, png)
  manifest[key] = hash
  const ms = performance.now() - start
  console.log(`✓ ${relative(".", outPath)} (${ms.toFixed(0)}ms)`)
  return ms
}

/** @param {string} dir @returns {Generator<string>} */
function* walkHtml(dir) {
  for (const entry of readdirSync(dir, { withFileTypes: true })) {
    if (entry.name === "og") continue
    const full = join(dir, entry.name)
    if (entry.isDirectory()) yield* walkHtml(full)
    else if (entry.name.endsWith(".html")) yield full
  }
}

/** @param {string} htmlPath @returns {Meta} */
function metaFromHtml(htmlPath) {
  const root = parse(readFileSync(htmlPath, "utf8"))
  const get = (/** @type {string} */ selector) => root.querySelector(selector)?.getAttribute("content")
  return {
    title:       get('meta[property="og:title"]') ?? root.querySelector("title")?.text,
    description: get('meta[property="og:description"]') ?? get('meta[name="description"]'),
    siteName:    get('meta[property="og:site_name"]'),
    imageUrl:    get('meta[property="og:image"]'),
  }
}

if (!existsSync(SITE_ROOT)) {
  console.error(`OG: site root not found at ${SITE_ROOT}. Run \`bin/bridgetown deploy\` first.`)
  process.exit(1)
}

/** @type {Meta} */
const homepageMeta = existsSync(join(SITE_ROOT, "index.html"))
  ? metaFromHtml(join(SITE_ROOT, "index.html"))
  : {}
const defaultSiteName = homepageMeta.siteName || "andrewm.codes"

const warnings = []
const renders = new Map()
const sources = new Map() // outPath → first HTML file that claimed it
const totalStart = performance.now()

for (const htmlFile of walkHtml(SITE_ROOT)) {
  const meta = metaFromHtml(htmlFile)
  if (!meta.imageUrl) continue

  const match = meta.imageUrl.match(/\/og\/([A-Za-z0-9._-]+\.png)$/)
  if (!match) continue

  const outPath = join(SITE_ROOT, "og", match[1])
  const payload = {
    title:       meta.title       || homepageMeta.title       || defaultSiteName,
    description: meta.description || homepageMeta.description || "",
    siteName:    meta.siteName    || defaultSiteName,
  }

  if (renders.has(outPath)) {
    // Two pages resolved to the same /og/<slug>.png. We can only write one
    // file, so the first wins — but if their content differs this is a real
    // slug collision (e.g. a post and a page sharing a basename). Warn loudly
    // rather than silently dropping the second page's card. Paginated pages
    // (/…/page/N/) intentionally reuse their parent's card, so skip those.
    const isPaginated = /\/page\/\d+\//.test(htmlFile)
    const prev = renders.get(outPath)
    if (!isPaginated && (prev.title !== payload.title || prev.description !== payload.description)) {
      warnings.push(
        `slug collision on ${match[1]}: ${relative(".", htmlFile)} dropped — already claimed by ${relative(".", sources.get(outPath))}`,
      )
    }
    continue
  }

  if (!meta.title) {
    warnings.push(`missing title: ${relative(".", htmlFile)} → fallback used`)
  }
  if (!meta.description) {
    warnings.push(`missing description: ${relative(".", htmlFile)}`)
  }

  sources.set(outPath, htmlFile)
  renders.set(outPath, payload)
}

const defaultPath = join(SITE_ROOT, "og", "default.png")
if (!renders.has(defaultPath)) {
  renders.set(defaultPath, {
    title:       homepageMeta.title       || defaultSiteName,
    description: homepageMeta.description || "",
    siteName:    defaultSiteName,
  })
}

let totalRenderMs = 0
for (const [outPath, payload] of renders) {
  totalRenderMs += await render(payload, outPath)
}

mkdirSync(CACHE_DIR, { recursive: true })
writeFileSync(MANIFEST_PATH, JSON.stringify(manifest, null, 2))

const elapsed = performance.now() - totalStart
const count = renders.size
const avg = count > 0 ? (totalRenderMs / count).toFixed(0) : 0
console.log(`OG: ${count} images in ${elapsed.toFixed(0)}ms total (avg ${avg}ms/image).`)

if (warnings.length) {
  console.warn(`OG: ${warnings.length} warning${warnings.length === 1 ? "" : "s"}:`)
  for (const w of warnings) console.warn(`  - ${w}`)
}
