// Live price estimate for the booking form. Recomputes whenever the selected
// dates (via the calendar's "booking:change" event), the number of guests, or
// the linen option change. Mirrors the server-side calculation in Bookings.

function money(box) {
  const map = {nl: "nl-NL", de: "de-DE", en: "en-IE"}
  const bcp = map[box.dataset.locale] || "nl-NL"
  const nf = new Intl.NumberFormat(bcp, {style: "currency", currency: "EUR"})
  return n => nf.format(n)
}

function toNumber(v) {
  return parseFloat(String(v || "0").replace(",", ".")) || 0
}

function parseDate(v) {
  if (!v) return null
  const [y, m, d] = v.split("-").map(Number)
  return new Date(y, m - 1, d)
}

export function initBookingPrice() {
  const box = document.querySelector("[data-price-breakdown]")
  if (!box) return

  const price = {
    night: toNumber(box.dataset.priceNight),
    cleaning: toNumber(box.dataset.priceCleaning),
    energy: toNumber(box.dataset.priceEnergy),
    tax: toNumber(box.dataset.priceTax),
    linen: toNumber(box.dataset.priceLinen)
  }
  const fmt = money(box)
  const arrival = document.querySelector(box.dataset.arrival)
  const departure = document.querySelector(box.dataset.departure)
  const persons = document.querySelector(box.dataset.persons)
  const linen = box.dataset.linen && document.querySelector(box.dataset.linen)
  const rowsEl = box.querySelector("[data-price-rows]")
  const totalEl = box.querySelector("[data-price-total]")
  const label = key => box.dataset[key] || ""

  function row(name, detail, amount) {
    const d = detail ? ` <span class="op-price-detail">${detail}</span>` : ""
    return `<div class="op-price-row"><span>${name}${d}</span><span>${fmt(amount)}</span></div>`
  }

  function recompute() {
    const a = parseDate(arrival && arrival.value)
    const b = parseDate(departure && departure.value)
    const guests = parseInt(persons && persons.value, 10) || 0
    const linenOn = linen ? linen.checked : false

    if (!a || !b || b <= a) {
      box.classList.add("hidden")
      return
    }

    const nights = Math.round((b - a) / 86400000)
    const nightsWord = box.dataset.lNights || ""
    const rows = []

    const nightTotal = price.night * nights
    rows.push(row(label("lNight"), `${nights} ${nightsWord} × ${fmt(price.night)}`, nightTotal))

    if (price.cleaning) rows.push(row(label("lCleaning"), "", price.cleaning))

    const energyTotal = price.energy * nights
    if (price.energy) rows.push(row(label("lEnergy"), `${nights} × ${fmt(price.energy)}`, energyTotal))

    let taxTotal = 0
    if (guests > 0 && price.tax) {
      taxTotal = price.tax * guests * nights
      const p = box.dataset.lPersons || ""
      rows.push(row(label("lTax"), `${guests} ${p} × ${nights} × ${fmt(price.tax)}`, taxTotal))
    }

    let linenTotal = 0
    if (linenOn && price.linen && guests > 0) {
      linenTotal = price.linen * guests
      const p = box.dataset.lPersons || ""
      rows.push(row(label("lLinen"), `${guests} ${p} × ${fmt(price.linen)}`, linenTotal))
    }

    rowsEl.innerHTML = rows.join("")
    totalEl.textContent = fmt(nightTotal + price.cleaning + energyTotal + taxTotal + linenTotal)
    box.classList.remove("hidden")
  }

  document.addEventListener("booking:change", recompute)
  if (persons) persons.addEventListener("input", recompute)
  if (linen) linen.addEventListener("change", recompute)
  recompute()
}
