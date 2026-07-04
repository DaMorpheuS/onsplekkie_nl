defmodule OnsplekkieNlWeb.AdminController do
  use OnsplekkieNlWeb, :controller

  alias OnsplekkieNl.Bookings
  alias OnsplekkieNl.Content
  alias OnsplekkieNl.Inquiries

  # Editable text fields, grouped for the content editor.
  # Each field is {key, label, type} where type is :text, :textarea or :list.
  @content_groups [
    {"Algemeen & contact",
     [
       {"site_title", "Sitenaam", :text},
       {"site_tagline", "Slogan", :text},
       {"contact_phone", "Telefoon", :text},
       {"contact_email", "E-mailadres", :text},
       {"contact_address", "Adres", :text},
       {"contact_maps_query", "Google Maps zoekterm", :text}
     ]},
    {"Home — hero",
     [
       {"home_hero_subtitle", "Subtitel (klein)", :text},
       {"home_hero_title", "Titel", :text},
       {"home_hero_text", "Introtekst", :textarea}
     ]},
    {"Home — introductie",
     [
       {"home_intro_eyebrow", "Bovenschrift", :text},
       {"home_intro_title", "Titel", :textarea},
       {"home_intro_text", "Tekst", :textarea}
     ]},
    {"Home — accommodatie",
     [
       {"home_accommodatie_title", "Titel", :text},
       {"home_accommodatie_text", "Tekst", :textarea}
     ]},
    {"Home — reviews",
     [
       {"home_reviews_title", "Titel", :text},
       {"review_1_name", "Review 1 — naam", :text},
       {"review_1_text", "Review 1 — tekst", :textarea},
       {"review_2_name", "Review 2 — naam", :text},
       {"review_2_text", "Review 2 — tekst", :textarea},
       {"review_3_name", "Review 3 — naam", :text},
       {"review_3_text", "Review 3 — tekst", :textarea}
     ]},
    {"Accommodatie-pagina",
     [
       {"accommodatie_title", "Paginatitel", :text},
       {"accommodatie_subtitle", "Subtitel", :text},
       {"accommodatie_intro_title", "Introtitel", :text},
       {"accommodatie_intro_text", "Introtekst", :textarea},
       {"accommodatie_amenities_title", "Titel voorzieningen", :text},
       {"accommodatie_amenities", "Voorzieningen (één per regel)", :list}
     ]},
    {"Omgeving-pagina",
     [
       {"omgeving_title", "Paginatitel", :text},
       {"omgeving_subtitle", "Subtitel", :text},
       {"omgeving_text", "Tekst", :textarea}
     ]},
    {"Reserveren-pagina",
     [
       {"reserveren_title", "Paginatitel", :text},
       {"reserveren_intro_title", "Introtitel", :text},
       {"reserveren_intro_text", "Introtekst", :textarea},
       {"reserveren_rates_title", "Titel tarieven", :text},
       {"reserveren_rates", "Tarieven (één per regel)", :list},
       {"reserveren_note", "Opmerking", :textarea}
     ]},
    {"Contact-pagina",
     [
       {"contact_title", "Paginatitel", :text},
       {"contact_intro_title", "Introtitel", :text},
       {"contact_intro_text", "Introtekst", :textarea}
     ]},
    {"Footer",
     [
       {"footer_tagline", "Slogan", :textarea},
       {"footer_reserveren_text", "Reserveren-tekst", :textarea},
       {"footer_credit", "Credit", :text}
     ]}
  ]

  def content_groups, do: @content_groups

  def index(conn, _params) do
    reservations = Bookings.list_reservations()
    messages = Inquiries.list_messages()

    render(conn, :dashboard,
      active: :dashboard,
      page_title: "Dashboard",
      reservation_count: length(reservations),
      new_reservation_count: Enum.count(reservations, &(&1.status == "reserved")),
      message_count: length(messages),
      new_message_count: Enum.count(messages, &(!&1.handled)),
      image_count: count_images(),
      setting_count: length(Content.list_settings())
    )
  end

  @locales OnsplekkieNlWeb.I18n.locales()

  def content(conn, params) do
    locale = if params["locale"] in @locales, do: params["locale"], else: "nl"

    render(conn, :content,
      active: :content,
      page_title: "Teksten bewerken",
      groups: @content_groups,
      locales: @locales,
      locale: locale,
      # Raw values for the chosen locale (blank where not yet translated)…
      values: Content.settings_raw(locale),
      # …and the Dutch values to show as placeholders/guidance.
      base: Content.settings_raw("nl")
    )
  end

  def update_content(conn, %{"settings" => settings} = params) when is_map(settings) do
    locale = if params["locale"] in @locales, do: params["locale"], else: "nl"
    Content.update_settings(settings, locale)

    conn
    |> put_flash(:info, "Teksten opgeslagen (#{String.upcase(locale)}).")
    |> redirect(to: ~p"/admin/content?locale=#{locale}")
  end

  defp count_images do
    Content.images_by_collection()
    |> Enum.reduce(0, fn {_k, v}, acc -> acc + length(v) end)
  end
end
