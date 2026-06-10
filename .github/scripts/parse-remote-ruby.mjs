import { readFileSync } from "node:fs"

const data = JSON.parse(readFileSync(process.argv[2], "utf8"))
if (!Array.isArray(data) || data.length === 0) {
  console.error("No episodes returned from Buzzsprout")
  process.exit(1)
}

const now = Date.now()
const latest = data
  .filter((ep) => !ep.private && ep.published_at && new Date(ep.published_at).getTime() <= now)
  .sort((a, b) => new Date(b.published_at) - new Date(a.published_at))[0]

if (!latest) {
  console.error("No published episodes found")
  process.exit(1)
}

process.stdout.write(JSON.stringify({
  id: latest.id,
  title: latest.title,
  url: latest.audio_url.replace(/\.mp3$/, ""),
  published_at: latest.published_at,
  description: latest.description,
  duration: latest.duration,
  episode_number: latest.episode_number,
  artwork_url: latest.artwork_url
}, null, 2) + "\n")
