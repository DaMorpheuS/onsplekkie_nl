// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//
// If you have dependencies that try to import CSS, esbuild will generate a separate `app.css` file.
// To load it, simply add a second `<link>` to your `root.html.heex` file.

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import {Socket} from "phoenix"
import {LiveSocket} from "phoenix_live_view"
import {hooks as colocatedHooks} from "phoenix-colocated/onsplekkie_nl"
import topbar from "../vendor/topbar"

const csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
const liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: {_csrf_token: csrfToken},
  hooks: {...colocatedHooks},
})

// Show progress bar on live navigation and form submits
topbar.config({barColors: {0: "#29d"}, shadowColor: "rgba(0, 0, 0, .3)"})
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

// The lines below enable quality of life phoenix_live_reload
// development features:
//
//     1. stream server logs to the browser console
//     2. click on elements to jump to their definitions in your code editor
//
// ---------------------------------------------------------------------------
// Scroll animations (Divi-style reveal-on-scroll + subtle background parallax)
// ---------------------------------------------------------------------------
const reduceMotion = window.matchMedia("(prefers-reduced-motion: reduce)").matches

function initScrollAnimations() {
  const revealEls = document.querySelectorAll("[data-animate]")

  if (reduceMotion || !("IntersectionObserver" in window)) {
    revealEls.forEach(el => el.classList.add("op-in"))
    return
  }

  const observer = new IntersectionObserver(
    (entries, obs) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add("op-in")
          obs.unobserve(entry.target)
        }
      })
    },
    {threshold: 0.12, rootMargin: "0px 0px -8% 0px"}
  )

  revealEls.forEach(el => observer.observe(el))

  // Subtle parallax on flagged background images.
  const parallaxEls = Array.from(document.querySelectorAll("[data-parallax]"))
  if (parallaxEls.length && !reduceMotion) {
    let ticking = false
    const update = () => {
      const vh = window.innerHeight
      parallaxEls.forEach(el => {
        const rect = el.getBoundingClientRect()
        if (rect.bottom < 0 || rect.top > vh) return
        const speed = parseFloat(el.dataset.parallax) || 0.15
        const shift = (rect.top + rect.height / 2 - vh / 2) * -speed
        el.style.transform = `translate3d(0, ${shift.toFixed(1)}px, 0) scale(1.18)`
      })
      ticking = false
    }
    const onScroll = () => {
      if (!ticking) {
        window.requestAnimationFrame(update)
        ticking = true
      }
    }
    window.addEventListener("scroll", onScroll, {passive: true})
    window.addEventListener("resize", onScroll, {passive: true})
    update()
  }
}

// ---------------------------------------------------------------------------
// Image lightbox: click a gallery image to open a full-screen viewer with
// previous/next navigation through that gallery's images.
// ---------------------------------------------------------------------------
function initLightbox() {
  const box = document.getElementById("op-lightbox")
  if (!box) return

  const imgEl = box.querySelector("[data-lb-image]")
  const curEl = box.querySelector("[data-lb-current]")
  const totEl = box.querySelector("[data-lb-total]")

  // Group all triggers on the page by their data-lightbox value.
  const groups = {}
  const triggers = document.querySelectorAll("[data-lightbox]")
  triggers.forEach(el => {
    const name = el.getAttribute("data-lightbox")
    const list = (groups[name] = groups[name] || [])
    list.push({src: el.getAttribute("href"), alt: el.querySelector("img")?.alt || ""})
  })

  let current = []
  let index = 0

  const show = i => {
    if (!current.length) return
    index = (i + current.length) % current.length
    const item = current[index]
    imgEl.src = item.src
    imgEl.alt = item.alt
    if (curEl) curEl.textContent = index + 1
    if (totEl) totEl.textContent = current.length
  }

  const open = (name, i) => {
    current = groups[name] || []
    if (!current.length) return
    box.classList.toggle("op-lb-single", current.length <= 1)
    box.classList.add("is-open")
    box.setAttribute("aria-hidden", "false")
    document.body.style.overflow = "hidden"
    show(i)
  }

  const close = () => {
    box.classList.remove("is-open")
    box.setAttribute("aria-hidden", "true")
    document.body.style.overflow = ""
    imgEl.src = ""
  }

  triggers.forEach(el => {
    el.addEventListener("click", e => {
      e.preventDefault()
      const name = el.getAttribute("data-lightbox")
      const href = el.getAttribute("href")
      const i = (groups[name] || []).findIndex(x => x.src === href)
      open(name, i < 0 ? 0 : i)
    })
  })

  box.querySelector("[data-lb-next]")?.addEventListener("click", () => show(index + 1))
  box.querySelector("[data-lb-prev]")?.addEventListener("click", () => show(index - 1))
  box.querySelectorAll("[data-lb-close]").forEach(b => b.addEventListener("click", close))

  // Click on the dark backdrop (but not the image or buttons) closes.
  box.addEventListener("click", e => {
    if (e.target === box) close()
  })

  document.addEventListener("keydown", e => {
    if (!box.classList.contains("is-open")) return
    if (e.key === "Escape") close()
    else if (e.key === "ArrowRight") show(index + 1)
    else if (e.key === "ArrowLeft") show(index - 1)
  })
}

function initInteractions() {
  initScrollAnimations()
  initLightbox()
}

if (document.readyState !== "loading") {
  initInteractions()
} else {
  document.addEventListener("DOMContentLoaded", initInteractions)
}

if (process.env.NODE_ENV === "development") {
  window.addEventListener("phx:live_reload:attached", ({detail: reloader}) => {
    // Enable server log streaming to client.
    // Disable with reloader.disableServerLogs()
    reloader.enableServerLogs()

    // Open configured PLUG_EDITOR at file:line of the clicked element's HEEx component
    //
    //   * click with "c" key pressed to open at caller location
    //   * click with "d" key pressed to open at function component definition location
    let keyDown
    window.addEventListener("keydown", e => keyDown = e.key)
    window.addEventListener("keyup", _e => keyDown = null)
    window.addEventListener("click", e => {
      if(keyDown === "c"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtCaller(e.target)
      } else if(keyDown === "d"){
        e.preventDefault()
        e.stopImmediatePropagation()
        reloader.openEditorAtDef(e.target)
      }
    }, true)

    window.liveReloader = reloader
  })
}

