// Marks the contents entry for the section you are actually reading.
//
// The rail is built at build time by Builders::Inspectors::Toc; this only
// tracks position. `aria-current` carries the state so the accessible and the
// visual state cannot drift apart — the styling hangs off that attribute.

// Just below the sticky header, so a heading becomes current as it arrives
// under the chrome rather than when it first peeks into view.
const LINE = 120

const start = () => {
  const nav = document.querySelector("[data-toc]")
  if (!nav) return

  const links = [...nav.querySelectorAll("a[href^='#']")]
  const entries = links
    .map((link) => ({
      link,
      heading: document.getElementById(decodeURIComponent(link.hash.slice(1))),
    }))
    .filter(({ heading }) => heading)

  if (entries.length === 0) return

  let current = null

  const sync = () => {
    // Positions are read live. An IntersectionObserver's cached rects are
    // captured when the entry fires, so during a long section they describe
    // where a heading *was* — which marks the wrong entry current.
    const passed = entries.filter(({ heading }) => heading.getBoundingClientRect().top < LINE)
    const active = (passed.at(-1) ?? entries[0]).link
    if (active === current) return

    current?.removeAttribute("aria-current")
    active.setAttribute("aria-current", "true")
    current = active
  }

  let queued = false
  const onScroll = () => {
    if (queued) return
    queued = true
    requestAnimationFrame(() => {
      queued = false
      sync()
    })
  }

  addEventListener("scroll", onScroll, { passive: true })
  addEventListener("resize", onScroll, { passive: true })
  sync()
}

if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", start, { once: true })
} else {
  start()
}

// Cross-document view transitions swap the body without a fresh page load.
document.addEventListener("turbo:load", start)
