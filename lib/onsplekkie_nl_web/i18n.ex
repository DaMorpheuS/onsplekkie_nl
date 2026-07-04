defmodule OnsplekkieNlWeb.I18n do
  @moduledoc """
  Lightweight translations for the static UI chrome (navigation, buttons, form
  labels, flash messages). Editable page *content* lives in the database and is
  translated per locale via `OnsplekkieNl.Content`.
  """

  @default "nl"
  @locales ~w(nl en de)

  @doc "Supported locale codes, default first."
  def locales, do: @locales
  def default_locale, do: @default
  def supported?(locale), do: locale in @locales

  @doc "Human name of each language, shown in the picker tooltip."
  def language_name("nl"), do: "Nederlands"
  def language_name("en"), do: "English"
  def language_name("de"), do: "Deutsch"
  def language_name(_), do: ""

  @strings %{
    # Navigation
    "nav.home" => %{"nl" => "Home", "en" => "Home", "de" => "Startseite"},
    "nav.accommodatie" => %{"nl" => "Accommodatie", "en" => "Accommodation", "de" => "Unterkunft"},
    "nav.omgeving" => %{"nl" => "Omgeving", "en" => "Surroundings", "de" => "Umgebung"},
    "nav.reserveren" => %{"nl" => "Reserveren", "en" => "Booking", "de" => "Reservieren"},
    "nav.contact" => %{"nl" => "Contact", "en" => "Contact", "de" => "Kontakt"},
    "nav.book_now" => %{"nl" => "Boek nu", "en" => "Book now", "de" => "Jetzt buchen"},

    # Footer
    "footer.pages" => %{"nl" => "Pagina's", "en" => "Pages", "de" => "Seiten"},
    "footer.contact_location" => %{
      "nl" => "Contact & locatie",
      "en" => "Contact & location",
      "de" => "Kontakt & Lage"
    },
    "footer.reserveren" => %{"nl" => "Reserveren", "en" => "Booking", "de" => "Reservierung"},
    "footer.reserveren_button" => %{
      "nl" => "Reserveren",
      "en" => "Book now",
      "de" => "Reservieren"
    },

    # Home buttons
    "home.btn_accommodatie" => %{
      "nl" => "De Accommodatie",
      "en" => "The Accommodation",
      "de" => "Die Unterkunft"
    },
    "home.btn_reserveren" => %{"nl" => "Reserveren", "en" => "Book now", "de" => "Reservieren"},
    "home.btn_omgeving" => %{
      "nl" => "Meer over de omgeving",
      "en" => "More about the area",
      "de" => "Mehr über die Umgebung"
    },
    "home.btn_book_now" => %{
      "nl" => "Reserveer nu",
      "en" => "Book now",
      "de" => "Jetzt reservieren"
    },

    # Accommodatie page
    "acc.photos" => %{"nl" => "Foto's", "en" => "Photos", "de" => "Fotos"},
    "acc.floorplans" => %{"nl" => "Plattegronden", "en" => "Floor plans", "de" => "Grundrisse"},
    "acc.reserveren_button" => %{
      "nl" => "Reserveren",
      "en" => "Book now",
      "de" => "Reservieren"
    },

    # Omgeving page
    "omg.heading" => %{
      "nl" => "De omgeving",
      "en" => "The surroundings",
      "de" => "Die Umgebung"
    },
    "omg.btn_accommodatie" => %{
      "nl" => "Naar de accommodatie",
      "en" => "To the accommodation",
      "de" => "Zur Unterkunft"
    },
    "omg.gallery_heading" => %{
      "nl" => "Beeld van de omgeving",
      "en" => "Impressions of the area",
      "de" => "Eindrücke der Umgebung"
    },

    # Lightbox
    "lb.close" => %{"nl" => "Sluiten", "en" => "Close", "de" => "Schließen"},
    "lb.prev" => %{"nl" => "Vorige", "en" => "Previous", "de" => "Zurück"},
    "lb.next" => %{"nl" => "Volgende", "en" => "Next", "de" => "Weiter"},

    # Contact page
    "contact.map_title" => %{
      "nl" => "Locatie Ons Plekkie",
      "en" => "Location Ons Plekkie",
      "de" => "Lage Ons Plekkie"
    },

    # Form labels
    "form.first_name" => %{"nl" => "Voornaam", "en" => "First name", "de" => "Vorname"},
    "form.last_name" => %{"nl" => "Achternaam", "en" => "Last name", "de" => "Nachname"},
    "form.phone" => %{"nl" => "Telefoon", "en" => "Phone", "de" => "Telefon"},
    "form.email" => %{"nl" => "E-mail", "en" => "Email", "de" => "E-Mail"},
    "form.address" => %{"nl" => "Adres", "en" => "Address", "de" => "Adresse"},
    "form.postcode" => %{"nl" => "Postcode", "en" => "Postal code", "de" => "Postleitzahl"},
    "form.city" => %{"nl" => "Plaats", "en" => "City", "de" => "Ort"},
    "form.num_persons" => %{
      "nl" => "Aantal personen",
      "en" => "Number of guests",
      "de" => "Anzahl Personen"
    },
    "form.arrival" => %{"nl" => "Aankomst", "en" => "Arrival", "de" => "Anreise"},
    "form.departure" => %{"nl" => "Vertrek", "en" => "Departure", "de" => "Abreise"},
    "form.comments" => %{"nl" => "Opmerkingen", "en" => "Comments", "de" => "Anmerkungen"},
    "form.question" => %{"nl" => "Uw vraag", "en" => "Your question", "de" => "Ihre Frage"},
    "form.submit_reservation" => %{
      "nl" => "Aanvraag versturen",
      "en" => "Send request",
      "de" => "Anfrage senden"
    },
    "form.submit_contact" => %{"nl" => "Versturen", "en" => "Send", "de" => "Senden"},

    # Flash messages
    "flash.reservation_ok" => %{
      "nl" => "Bedankt voor uw aanvraag! Wij nemen zo spoedig mogelijk contact met u op.",
      "en" => "Thank you for your request! We will contact you as soon as possible.",
      "de" => "Vielen Dank für Ihre Anfrage! Wir melden uns so schnell wie möglich bei Ihnen."
    },
    "flash.message_ok" => %{
      "nl" => "Bedankt voor uw bericht! Wij reageren zo snel mogelijk.",
      "en" => "Thank you for your message! We will respond as soon as possible.",
      "de" => "Vielen Dank für Ihre Nachricht! Wir antworten so schnell wie möglich."
    }
  }

  @doc "Translate a static UI key for the given locale, falling back to Dutch."
  def t(locale, key) do
    case @strings[key] do
      nil -> key
      variants -> variants[locale] || variants[@default] || key
    end
  end
end
