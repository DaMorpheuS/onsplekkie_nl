// Availability calendar with arrival→departure range selection.
//
// Reads occupied nights (ISO date strings) from a container's data attributes,
// renders two months of clickable days, and writes the chosen dates into the
// linked <input> elements. Also supports a read-only overview mode for admin.

function pad(n) {
  return String(n).padStart(2, "0")
}
function ymd(d) {
  return `${d.getFullYear()}-${pad(d.getMonth() + 1)}-${pad(d.getDate())}`
}
function parseYMD(s) {
  const [y, m, d] = s.split("-").map(Number)
  return new Date(y, m - 1, d)
}
function addDays(d, n) {
  const c = new Date(d)
  c.setDate(c.getDate() + n)
  return c
}
function nights(a, b) {
  return Math.round((b - a) / 86400000)
}
function el(tag, cls) {
  const e = document.createElement(tag)
  if (cls) e.className = cls
  return e
}

function build(root) {
  const occupied = new Set(JSON.parse(root.dataset.occupied || "[]"))
  const readonly = root.hasAttribute("data-readonly")
  const locale = root.dataset.locale || document.documentElement.lang || "nl"
  const today = root.dataset.today ? parseYMD(root.dataset.today) : new Date(new Date().toDateString())
  const monthsToShow = parseInt(root.dataset.months || "2", 10)
  const nightsLabel = root.dataset.labelNights || "nights"

  const arrivalInput = root.dataset.arrival && document.querySelector(root.dataset.arrival)
  const departureInput = root.dataset.departure && document.querySelector(root.dataset.departure)
  const summaryEl = root.dataset.summary && document.querySelector(root.dataset.summary)
  const nativeEl = root.dataset.native && document.querySelector(root.dataset.native)

  // The calendar drives the real date inputs, so hide the plain fallback ones.
  if (nativeEl && !readonly) nativeEl.style.display = "none"

  let arrival = null
  let departure = null
  if (arrivalInput && arrivalInput.value) arrival = parseYMD(arrivalInput.value)
  if (departureInput && departureInput.value) departure = parseYMD(departureInput.value)

  const startFrom = arrival && arrival >= today ? arrival : today
  let view = new Date(startFrom.getFullYear(), startFrom.getMonth(), 1)

  const isOccupied = d => occupied.has(ymd(d))
  const isPast = d => d < today
  const rangeFree = (a, b) => {
    for (let d = new Date(a); d < b; d = addDays(d, 1)) if (isOccupied(d)) return false
    return true
  }
  const fmt = d => d.toLocaleDateString(locale, {day: "numeric", month: "short", year: "numeric"})

  function writeInputs() {
    if (arrivalInput) arrivalInput.value = arrival ? ymd(arrival) : ""
    if (departureInput) departureInput.value = departure ? ymd(departure) : ""
    if (summaryEl) {
      if (arrival && departure) {
        summaryEl.textContent = `${fmt(arrival)} → ${fmt(departure)} · ${nights(arrival, departure)} ${nightsLabel}`
      } else if (arrival) {
        summaryEl.textContent = `${fmt(arrival)} → …`
      } else {
        summaryEl.textContent = ""
      }
    }
    document.dispatchEvent(new CustomEvent("booking:change"))
  }

  function pick(d) {
    if (readonly || isPast(d)) return
    if (!arrival || (arrival && departure)) {
      if (isOccupied(d)) return
      arrival = d
      departure = null
    } else if (d <= arrival) {
      if (!isOccupied(d)) {
        arrival = d
        departure = null
      }
    } else if (rangeFree(arrival, d)) {
      departure = d
    } else if (!isOccupied(d)) {
      arrival = d
      departure = null
    }
    writeInputs()
    render()
  }

  function inRange(d) {
    if (arrival && departure) return d >= arrival && d <= departure
    return arrival && ymd(d) === ymd(arrival)
  }

  function renderMonth(monthDate) {
    const wrap = el("div", "op-cal-month")
    const grid = el("div", "op-cal-grid")

    const monday = new Date(2024, 0, 1) // a Monday, for weekday labels
    for (let i = 0; i < 7; i++) {
      const wd = el("div", "op-cal-wd")
      wd.textContent = addDays(monday, i).toLocaleDateString(locale, {weekday: "short"})
      grid.append(wd)
    }

    const first = new Date(monthDate.getFullYear(), monthDate.getMonth(), 1)
    const lead = (first.getDay() + 6) % 7 // make Monday the first column
    for (let i = 0; i < lead; i++) grid.append(el("div", "op-cal-empty"))

    const days = new Date(monthDate.getFullYear(), monthDate.getMonth() + 1, 0).getDate()
    for (let day = 1; day <= days; day++) {
      const d = new Date(monthDate.getFullYear(), monthDate.getMonth(), day)
      const cell = el("button", "op-cal-day")
      cell.type = "button"
      cell.textContent = day
      if (isPast(d)) cell.classList.add("is-past")
      else if (isOccupied(d)) cell.classList.add("is-occupied")
      if (inRange(d)) cell.classList.add("is-selected")
      if (arrival && ymd(d) === ymd(arrival)) cell.classList.add("is-start")
      if (departure && ymd(d) === ymd(departure)) cell.classList.add("is-end")
      if (isPast(d) || readonly) cell.disabled = true
      cell.addEventListener("click", () => pick(d))
      grid.append(cell)
    }
    wrap.append(grid)
    return wrap
  }

  function render() {
    root.innerHTML = ""

    const header = el("div", "op-cal-header")
    const prev = el("button", "op-cal-nav")
    const next = el("button", "op-cal-nav")
    prev.type = next.type = "button"
    prev.innerHTML = "&#8249;"
    next.innerHTML = "&#8250;"
    if (root.dataset.labelPrev) prev.setAttribute("aria-label", root.dataset.labelPrev)
    if (root.dataset.labelNext) next.setAttribute("aria-label", root.dataset.labelNext)
    prev.addEventListener("click", () => {
      view = new Date(view.getFullYear(), view.getMonth() - 1, 1)
      render()
    })
    next.addEventListener("click", () => {
      view = new Date(view.getFullYear(), view.getMonth() + 1, 1)
      render()
    })
    if (!readonly && view <= new Date(today.getFullYear(), today.getMonth(), 1)) {
      prev.disabled = true
    }

    const titles = []
    const months = el("div", "op-cal-months")
    for (let i = 0; i < monthsToShow; i++) {
      const m = new Date(view.getFullYear(), view.getMonth() + i, 1)
      titles.push(m.toLocaleDateString(locale, {month: "long", year: "numeric"}))
      months.append(renderMonth(m))
    }

    const title = el("div", "op-cal-title")
    title.textContent = titles.join("  ·  ")

    header.append(prev, title, next)
    root.append(header, months)
  }

  render()
  writeInputs()
}

export function initBookingCalendars() {
  document.querySelectorAll("[data-booking-calendar]").forEach(build)
}
