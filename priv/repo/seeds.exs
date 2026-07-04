# Populates the database with the default "Ons Plekkie" content and images.
#
#     mix run priv/repo/seeds.exs
#
# Text settings are only inserted when missing, so re-running never clobbers
# edits made through the admin backend. Images are seeded once (when empty).

alias OnsplekkieNl.Repo
alias OnsplekkieNl.Content
alias OnsplekkieNl.Content.{Setting, Image}

put_new = fn key, value, locale ->
  case Repo.get_by(Setting, key: key, locale: locale) do
    nil -> Content.put_setting(key, value, locale)
    _ -> :ok
  end
end

settings = %{
  # Global / contact
  "site_title" => "Ons Plekkie",
  "site_tagline" => "Vakantiewoning aan het Hilgelo meer",
  "contact_phone" => "+31628121074",
  "contact_email" => "w.te.nijenhuis@hccnet.nl",
  "contact_address" => "Hilgeloweg 2-15, 7104 BG Winterswijk Meddo",
  "contact_maps_query" => "Hilgeloweg 2, Winterswijk Meddo",

  # Home — hero
  "home_hero_title" => "Boek onze sfeervolle vakantiewoning",
  "home_hero_subtitle" => "‘Ons plekkie’",
  "home_hero_text" =>
    "Gelegen nabij het “Hilgelo meer”, een natuurlijke waterplas omgeven met strand, bos en wandelpaden. Ideaal voor wandelaars, vissers, fietsers of andere waterliefhebbers.",

  # Home — intro
  "home_intro_eyebrow" => "Vakantiewoning “ons plekkie”",
  "home_intro_title" =>
    "Deze sfeervolle vakantiewoning is gelegen op een prachtige locatie aan het recreatiepark “Sevink Molen” in het prachtige groene Achterhoek te Winterswijk.",
  "home_intro_text" =>
    "Op 150 meter hier vandaan ligt “het Hilgelo”, een natuurlijke waterplas omgeven met strand, bos en wandelpaden. Deze vakantiewoning is ideaal voor wandelaars, vissers, fietsers of andere waterliefhebbers. De eindeloze wandel- en fietsroutes nemen u mee door de diverse buurtschappen. Op het aangrenzende recreatiepark “Sevink Molen” kunt u gebruik maken van het restaurant en voor de kinderen is er een overdekte binnen- en buitenspeelparadijs aanwezig.",

  # Home — accommodatie teaser
  "home_accommodatie_title" => "Overnachten in onze accommodatie",
  "home_accommodatie_text" =>
    "Ons vakantiehuis biedt plaats aan maximaal 6 personen. In de woonkamer is een bankstel, TV en een ruime eethoek voor zes personen aanwezig.",

  # Home — reviews
  "home_reviews_title" => "Wat zeggen onze gasten:",
  "review_1_name" => "Marleen",
  "review_1_text" =>
    "Wouter en Ingrid waren zeer flexibele en prettige hosts. De aankomst was aangenaam en daarna een goed verder verblijf gehad. Het huisje is van alle gemakken voorzien, de tuin is mooi en groot en dat alles op loopafstand van een prachtig meer. Kortom, het verblijf was top!",
  "review_2_name" => "Lief",
  "review_2_text" =>
    "Erg fijn huis, heel volledig en bovendien gezellig ingericht op een mooie locatie te midden van de natuur. Perfect voor een fiets- en watervakantie… Mooi meer met beach in de buurt. De hosts doen alles om het je naar de zin te maken en ze verwennen je bovendien met allerlei extra’s. Er stond koffie, wijn en lekkers op ons te wachten bij aankomst! Een dikke aanrader! Dank je wel Wouter en Ingrid!",
  "review_3_name" => "Jasmin",
  "review_3_text" =>
    "Rustige en mooie locatie! 5 minuten lopen naar het zwemmeer. Hondvriendelijk. We voelden ons allemaal erg op ons gemak. Mooie gezellige inrichting, zowel in huis als in de tuin. De verhuurder is erg aardig en begripvol. Zou het huis op elk moment weer huren!!",

  # Accommodatie page
  "accommodatie_title" => "Accommodatie",
  "accommodatie_subtitle" => "informatie over onze accommodatie",
  "accommodatie_intro_title" => "Ons vakantiehuis biedt plaats aan maximaal 6 personen",
  "accommodatie_intro_text" =>
    "In de woonkamer is een bankstel, TV en een ruime eethoek voor zes personen aanwezig. De open keuken is voorzien van een elektrische kookplaat, magnetron, oven, koelkast, diepvries, vaatwasser, koffiezetapparaat, waterkoker en een Dolce Gusto apparaat.\n\nOp de begane grond bevindt zich een slaapkamer met een eigen badkamer met bad en wasmachine. Op de bovenverdieping zijn twee ruime slaapkamers met elk twee eenpersoonsbedden, een douche, wastafel, toilet en een sauna. Kledingkasten, horren en rolluiken zijn aanwezig.\n\nEen kinderbedje en kinderstoel zijn op aanvraag beschikbaar.",
  "accommodatie_amenities_title" => "Voorzieningen",
  "accommodatie_amenities" =>
    Enum.join(
      [
        "Schoonmaakartikelen",
        "Kookgerei",
        "Bureau / werkplek",
        "Servies en bestek",
        "Verwarming",
        "Keuken",
        "TV",
        "Wasmachine",
        "WiFi / internet",
        "Bad",
        "Sauna",
        "Terras met buitenmeubilair",
        "Beddengoed",
        "Kledingopslag",
        "Wasrek",
        "Extra kussens en dekens",
        "Kledinghangers",
        "Horren",
        "Rolluiken / verduistering",
        "Boeken en tijdschriften",
        "Geluidsinstallatie",
        "Gratis parkeren",
        "Traphekje",
        "Kinderbedje",
        "Kinderstoel",
        "Openhaard",
        "Koolmonoxidemelder",
        "Rookmelder",
        "Broodrooster",
        "Koffiezetapparaat",
        "Eettafel",
        "Vaatwasser",
        "Diepvries",
        "Magnetron",
        "Oven",
        "Koelkast",
        "Wijnglazen",
        "Strand in de buurt",
        "Aan het water",
        "Tuin",
        "Barbecue"
      ],
      "\n"
    ),

  # Omgeving page
  "omgeving_title" => "Omgeving",
  "omgeving_subtitle" => "Op 150 meter ligt ‘het Hilgelo’, een natuurlijke waterplas.",
  "omgeving_text" =>
    "Het vakantiehuis is een vrijstaande woning op een ruime kavel van 660 m².\n\nOp 150 meter van het vakantiehuis vandaan ligt “het Hilgelo”, een natuurlijke waterplas omgeven met strand, bos en wandelpaden.\n\nOp enkele kilometers van het huisje ligt het centrum van Winterswijk, waar zich een scala aan mogelijkheden bevindt wat betreft grand-cafés en restaurants.\n\nOntspan en geniet van de natuur, het buitenleven en de rust bij het vakantiehuis.",

  # Reserveren page
  "reserveren_title" => "Reserveren",
  "reserveren_intro_title" => "Direct reserveren",
  "reserveren_intro_text" =>
    "Vul onderstaand formulier in om uw verblijf aan te vragen. Wij nemen zo spoedig mogelijk contact met u op om uw reservering te bevestigen.",
  "reserveren_rates_title" => "Tarieven",
  "reserveren_rates" =>
    Enum.join(
      [
        "€ 135,00 per nacht",
        "Bed-, bad- en keukenlinnen: € 10,00 per persoon (optioneel)",
        "Eindschoonmaak: € 100,00",
        "Energietoeslag: € 10,00 per dag",
        "Toeristenbelasting: € 1,85 per persoon per dag"
      ],
      "\n"
    ),
  "reserveren_note" => "Helaas zijn huisdieren niet toegestaan.",

  # Prices used by the booking calculator (numbers; use a dot as decimal sep.)
  "price_per_night" => "135.00",
  "price_cleaning" => "100.00",
  "price_energy_per_day" => "10.00",
  "price_tourist_tax_pppd" => "1.85",
  "price_linen_pp" => "10.00",

  # Contact page
  "contact_title" => "Contact",
  "contact_intro_title" => "Neem gerust contact met ons op",
  "contact_intro_text" =>
    "Wij, Ingrid & Wouter te Nijenhuis, heten u van harte welkom in onze vakantiewoning ‘Ons Plekkie’, gelegen op recreatiepark ‘Sevink Molen’. Wij bieden u rust, ruimte en comfort in een prachtige natuurlijke omgeving nabij Winterswijk.",

  # Footer
  "footer_tagline" =>
    "Deze sfeervolle vakantiewoning is gelegen op een prachtige locatie aan het recreatiepark ‘Sevink Molen’.",
  "footer_reserveren_text" =>
    "Ontspan en geniet van de natuur, het buitenleven en de rust bij het vakantiehuis.",
  "footer_credit" => "Webdesign: Remedia.nl"
}

Enum.each(settings, fn {k, v} -> put_new.(k, v, "nl") end)
IO.puts("Seeded #{map_size(settings)} NL settings.")

## English translations -----------------------------------------------------

en = %{
  "site_tagline" => "Holiday home by the Hilgelo lake",
  "home_hero_title" => "Book our charming holiday home",
  "home_hero_subtitle" => "‘Ons plekkie’",
  "home_hero_text" =>
    "Located near the “Hilgelo lake”, a natural lake surrounded by beach, forest and walking paths. Ideal for walkers, anglers, cyclists and other water lovers.",
  "home_intro_eyebrow" => "Holiday home “ons plekkie”",
  "home_intro_title" =>
    "This charming holiday home is set in a beautiful location at the “Sevink Molen” recreation park in the beautiful green Achterhoek region of Winterswijk.",
  "home_intro_text" =>
    "Just 150 metres away lies “the Hilgelo”, a natural lake surrounded by beach, forest and walking paths. This holiday home is ideal for walkers, anglers, cyclists and other water lovers. The endless walking and cycling routes take you through the various hamlets. At the adjacent “Sevink Molen” recreation park you can make use of the restaurant, and there is a covered indoor and outdoor play paradise for the children.",
  "home_accommodatie_title" => "Stay in our accommodation",
  "home_accommodatie_text" =>
    "Our holiday home accommodates up to 6 people. The living room has a sofa, TV and a spacious dining area for six.",
  "home_reviews_title" => "What our guests say:",
  "review_1_text" =>
    "Wouter and Ingrid were very flexible and pleasant hosts. The arrival was pleasant and we had a great stay. The house has every comfort, the garden is beautiful and large, and all within walking distance of a wonderful lake. In short, the stay was fantastic!",
  "review_2_text" =>
    "Very nice house, very complete and cosily furnished in a beautiful location amid nature. Perfect for a cycling and water holiday… A lovely lake with a beach nearby. The hosts do everything to make you feel at home and spoil you with all kinds of extras. Coffee, wine and treats were waiting for us on arrival! Highly recommended! Thank you Wouter and Ingrid!",
  "review_3_text" =>
    "Quiet and beautiful location! A 5-minute walk to the swimming lake. Dog-friendly. We all felt very much at ease. Lovely, cosy furnishing, both inside and in the garden. The owner is very kind and understanding. Would rent the house again any time!!",
  "accommodatie_title" => "Accommodation",
  "accommodatie_subtitle" => "information about our accommodation",
  "accommodatie_intro_title" => "Our holiday home accommodates up to 6 people",
  "accommodatie_intro_text" =>
    "The living room has a sofa, TV and a spacious dining area for six. The open kitchen is equipped with an electric hob, microwave, oven, fridge, freezer, dishwasher, coffee machine, kettle and a Dolce Gusto machine.\n\nOn the ground floor there is a bedroom with an en-suite bathroom with bath and washing machine. Upstairs there are two spacious bedrooms, each with two single beds, a shower, washbasin, toilet and a sauna. Wardrobes, insect screens and shutters are provided.\n\nA cot and high chair are available on request.",
  "accommodatie_amenities_title" => "Amenities",
  "accommodatie_amenities" =>
    Enum.join(
      [
        "Cleaning supplies",
        "Cookware",
        "Desk / workspace",
        "Crockery and cutlery",
        "Heating",
        "Kitchen",
        "TV",
        "Washing machine",
        "WiFi / internet",
        "Bath",
        "Sauna",
        "Terrace with outdoor furniture",
        "Bed linen",
        "Clothing storage",
        "Drying rack",
        "Extra pillows and blankets",
        "Coat hangers",
        "Insect screens",
        "Shutters / blackout",
        "Books and magazines",
        "Sound system",
        "Free parking",
        "Stair gate",
        "Cot",
        "High chair",
        "Fireplace",
        "Carbon monoxide detector",
        "Smoke detector",
        "Toaster",
        "Coffee machine",
        "Dining table",
        "Dishwasher",
        "Freezer",
        "Microwave",
        "Oven",
        "Refrigerator",
        "Wine glasses",
        "Beach nearby",
        "Waterfront",
        "Garden",
        "Barbecue"
      ],
      "\n"
    ),
  "omgeving_title" => "Surroundings",
  "omgeving_subtitle" => "150 metres away lies ‘the Hilgelo’, a natural lake.",
  "omgeving_text" =>
    "The holiday home is a detached house on a spacious plot of 660 m².\n\n150 metres from the holiday home lies “the Hilgelo”, a natural lake surrounded by beach, forest and walking paths.\n\nA few kilometres from the house is the centre of Winterswijk, which offers a wide range of grand cafés and restaurants.\n\nRelax and enjoy nature, the outdoor life and the peace and quiet at the holiday home.",
  "reserveren_title" => "Booking",
  "reserveren_intro_title" => "Book directly",
  "reserveren_intro_text" =>
    "Fill in the form below to request your stay. We will contact you as soon as possible to confirm your booking.",
  "reserveren_rates_title" => "Rates",
  "reserveren_rates" =>
    Enum.join(
      [
        "€ 135.00 per night",
        "Bed, bath and kitchen linen: € 10.00 per person (optional)",
        "Final cleaning: € 100.00",
        "Energy surcharge: € 10.00 per day",
        "Tourist tax: € 1.85 per person per day"
      ],
      "\n"
    ),
  "reserveren_note" => "Unfortunately, pets are not allowed.",
  "contact_title" => "Contact",
  "contact_intro_title" => "Feel free to get in touch",
  "contact_intro_text" =>
    "We, Ingrid & Wouter te Nijenhuis, warmly welcome you to our holiday home ‘Ons Plekkie’, located at the ‘Sevink Molen’ recreation park. We offer you peace, space and comfort in a beautiful natural setting near Winterswijk.",
  "footer_tagline" =>
    "This charming holiday home is set in a beautiful location at the ‘Sevink Molen’ recreation park.",
  "footer_reserveren_text" =>
    "Relax and enjoy nature, the outdoor life and the peace and quiet at the holiday home."
}

Enum.each(en, fn {k, v} -> put_new.(k, v, "en") end)
IO.puts("Seeded #{map_size(en)} EN settings.")

## German translations ------------------------------------------------------

de = %{
  "site_tagline" => "Ferienhaus am Hilgelo-See",
  "home_hero_title" => "Buchen Sie unser stimmungsvolles Ferienhaus",
  "home_hero_subtitle" => "‘Ons plekkie’",
  "home_hero_text" =>
    "In der Nähe des „Hilgelo-Sees“ gelegen, ein natürlicher See umgeben von Strand, Wald und Wanderwegen. Ideal für Wanderer, Angler, Radfahrer und andere Wasserliebhaber.",
  "home_intro_eyebrow" => "Ferienhaus „ons plekkie“",
  "home_intro_title" =>
    "Dieses stimmungsvolle Ferienhaus liegt an einem herrlichen Ort am Freizeitpark „Sevink Molen“ im schönen grünen Achterhoek in Winterswijk.",
  "home_intro_text" =>
    "Nur 150 Meter entfernt liegt „das Hilgelo“, ein natürlicher See umgeben von Strand, Wald und Wanderwegen. Dieses Ferienhaus ist ideal für Wanderer, Angler, Radfahrer und andere Wasserliebhaber. Die endlosen Wander- und Radwege führen Sie durch die verschiedenen Bauerschaften. Im angrenzenden Freizeitpark „Sevink Molen“ können Sie das Restaurant nutzen, und für die Kinder gibt es ein überdachtes Innen- und Außenspielparadies.",
  "home_accommodatie_title" => "Übernachten in unserer Unterkunft",
  "home_accommodatie_text" =>
    "Unser Ferienhaus bietet Platz für maximal 6 Personen. Im Wohnzimmer befinden sich eine Couchgarnitur, ein Fernseher und ein geräumiger Essbereich für sechs Personen.",
  "home_reviews_title" => "Was unsere Gäste sagen:",
  "review_1_text" =>
    "Wouter und Ingrid waren sehr flexible und angenehme Gastgeber. Die Ankunft war angenehm und danach hatten wir einen schönen Aufenthalt. Das Haus ist mit allem Komfort ausgestattet, der Garten ist schön und groß, und das alles in Gehweite zu einem herrlichen See. Kurzum, der Aufenthalt war top!",
  "review_2_text" =>
    "Sehr schönes Haus, sehr vollständig und zudem gemütlich eingerichtet an einem schönen Ort mitten in der Natur. Perfekt für einen Rad- und Wasserurlaub… Ein schöner See mit Strand in der Nähe. Die Gastgeber tun alles, damit man sich wohlfühlt, und verwöhnen einen mit allerlei Extras. Bei der Ankunft warteten Kaffee, Wein und Leckereien auf uns! Sehr zu empfehlen! Danke Wouter und Ingrid!",
  "review_3_text" =>
    "Ruhige und schöne Lage! 5 Minuten zu Fuß zum Badesee. Hundefreundlich. Wir haben uns alle sehr wohlgefühlt. Schöne, gemütliche Einrichtung, sowohl im Haus als auch im Garten. Der Vermieter ist sehr nett und verständnisvoll. Würde das Haus jederzeit wieder mieten!!",
  "accommodatie_title" => "Unterkunft",
  "accommodatie_subtitle" => "Informationen über unsere Unterkunft",
  "accommodatie_intro_title" => "Unser Ferienhaus bietet Platz für maximal 6 Personen",
  "accommodatie_intro_text" =>
    "Im Wohnzimmer befinden sich eine Couchgarnitur, ein Fernseher und ein geräumiger Essbereich für sechs Personen. Die offene Küche ist mit einem Elektrokochfeld, einer Mikrowelle, einem Backofen, einem Kühlschrank, einem Gefrierschrank, einer Spülmaschine, einer Kaffeemaschine, einem Wasserkocher und einer Dolce-Gusto-Maschine ausgestattet.\n\nIm Erdgeschoss befindet sich ein Schlafzimmer mit eigenem Bad mit Badewanne und Waschmaschine. Im Obergeschoss gibt es zwei geräumige Schlafzimmer mit jeweils zwei Einzelbetten, eine Dusche, ein Waschbecken, eine Toilette und eine Sauna. Kleiderschränke, Insektenschutzgitter und Rollläden sind vorhanden.\n\nEin Kinderbett und ein Hochstuhl sind auf Anfrage verfügbar.",
  "accommodatie_amenities_title" => "Ausstattung",
  "accommodatie_amenities" =>
    Enum.join(
      [
        "Reinigungsmittel",
        "Kochgeschirr",
        "Schreibtisch / Arbeitsplatz",
        "Geschirr und Besteck",
        "Heizung",
        "Küche",
        "Fernseher",
        "Waschmaschine",
        "WLAN / Internet",
        "Badewanne",
        "Sauna",
        "Terrasse mit Gartenmöbeln",
        "Bettwäsche",
        "Kleiderschrank",
        "Wäscheständer",
        "Zusätzliche Kissen und Decken",
        "Kleiderbügel",
        "Insektenschutzgitter",
        "Rollläden / Verdunkelung",
        "Bücher und Zeitschriften",
        "Soundanlage",
        "Kostenlose Parkplätze",
        "Treppenschutzgitter",
        "Kinderbett",
        "Hochstuhl",
        "Kamin",
        "Kohlenmonoxidmelder",
        "Rauchmelder",
        "Toaster",
        "Kaffeemaschine",
        "Esstisch",
        "Spülmaschine",
        "Gefrierschrank",
        "Mikrowelle",
        "Backofen",
        "Kühlschrank",
        "Weingläser",
        "Strand in der Nähe",
        "Am Wasser",
        "Garten",
        "Grill"
      ],
      "\n"
    ),
  "omgeving_title" => "Umgebung",
  "omgeving_subtitle" => "150 Meter entfernt liegt „das Hilgelo“, ein natürlicher See.",
  "omgeving_text" =>
    "Das Ferienhaus ist ein freistehendes Haus auf einem geräumigen Grundstück von 660 m².\n\n150 Meter vom Ferienhaus entfernt liegt „das Hilgelo“, ein natürlicher See umgeben von Strand, Wald und Wanderwegen.\n\nEinige Kilometer vom Haus entfernt liegt das Zentrum von Winterswijk mit einer Vielzahl von Grandcafés und Restaurants.\n\nEntspannen Sie und genießen Sie die Natur, das Leben im Freien und die Ruhe am Ferienhaus.",
  "reserveren_title" => "Reservieren",
  "reserveren_intro_title" => "Direkt reservieren",
  "reserveren_intro_text" =>
    "Füllen Sie das untenstehende Formular aus, um Ihren Aufenthalt anzufragen. Wir setzen uns so schnell wie möglich mit Ihnen in Verbindung, um Ihre Reservierung zu bestätigen.",
  "reserveren_rates_title" => "Preise",
  "reserveren_rates" =>
    Enum.join(
      [
        "€ 135,00 pro Nacht",
        "Bett-, Bade- und Küchenwäsche: € 10,00 pro Person (optional)",
        "Endreinigung: € 100,00",
        "Energiezuschlag: € 10,00 pro Tag",
        "Kurtaxe: € 1,85 pro Person pro Tag"
      ],
      "\n"
    ),
  "reserveren_note" => "Haustiere sind leider nicht erlaubt.",
  "contact_title" => "Kontakt",
  "contact_intro_title" => "Nehmen Sie gerne Kontakt mit uns auf",
  "contact_intro_text" =>
    "Wir, Ingrid & Wouter te Nijenhuis, heißen Sie herzlich willkommen in unserem Ferienhaus „Ons Plekkie“ im Freizeitpark „Sevink Molen“. Wir bieten Ihnen Ruhe, Raum und Komfort in einer wunderschönen natürlichen Umgebung nahe Winterswijk.",
  "footer_tagline" =>
    "Dieses stimmungsvolle Ferienhaus liegt an einem herrlichen Ort am Freizeitpark „Sevink Molen“.",
  "footer_reserveren_text" =>
    "Entspannen Sie und genießen Sie die Natur, das Leben im Freien und die Ruhe am Ferienhaus."
}

Enum.each(de, fn {k, v} -> put_new.(k, v, "de") end)
IO.puts("Seeded #{map_size(de)} DE settings.")

## Images -----------------------------------------------------------------

if Repo.aggregate(Image, :count) == 0 do
  p = fn file -> "/images/site/#{file}" end

  singles = [
    %{
      collection: "hero",
      slug: "hero",
      path: p.("vakantiewoning-hilgelo-meer2.jpg"),
      alt: "Vakantiewoning Ons Plekkie aan het Hilgelo meer"
    },
    %{
      collection: "home_intro",
      slug: "home_intro",
      path: p.("Luchtfoto-vakantie-woningen.jpg"),
      alt: "Luchtfoto van de vakantiewoningen"
    },
    %{
      collection: "home_accommodatie",
      slug: "home_accommodatie",
      path: p.("vakantiewoning-inrichting.jpg"),
      alt: "Interieur van de vakantiewoning"
    },
    %{
      collection: "omgeving_hero",
      slug: "omgeving_hero",
      path: p.("hilgelo-meer.jpg"),
      alt: "Het Hilgelo meer"
    },
    %{
      collection: "reserveren_hero",
      slug: "reserveren_hero",
      path: p.("vakantiewoning-tuin.jpg"),
      alt: "De tuin van de vakantiewoning"
    }
  ]

  gallery_accommodatie =
    ~w(vakantiewoning-hilgelo-meer.jpg vakantiewoning-hilgelo-meer3.jpg
       vakantiewoning-hilgelo-meer4.jpg vakantiewoning.jpg vakantiewoning2.jpg
       vakantiewoning-inrichting.jpg vakantiewoning-inrichting2.jpg
       vakantiewoning-inrichting3.jpg vakantiewoning-inrichting-hilgelo-meer1.jpg
       vakantiewoning-inrichting-hilgelo-meer2.jpg vakantiewoning-inrichting-hilgelo-meer3.jpg
       vakantiewoning-inrichting-hilgelo-meer4.jpg vakantiewoning-inrichting-hilgelo-meer5.jpg
       vakantiewoning-inrichting-hilgelo-meer6.jpg vakantiewoning-inrichting-hilgelo-meer7.jpg
       vakantiewoning-inrichting-hilgelo-meer8.jpg vakantiewoning-inrichting-hilgelo-meer9.jpg
       vakantiewoning-inrichting-hilgelo-meer11.jpg vakantiewoning-inrichting-hilgelo-meer13.jpg
       vakantiewoning-inrichting-hilgelo-meer14.jpg vakantiewoning-inrichting-hilgelo-meer15.jpg
       vakantiewoning-inrichting-hilgelo-meer16.jpg vakantiewoning-tuin.jpg
       vakantiewoning-tuin2.jpg vakantiewoning-tuin3.jpg vakantiewoning-tuin4.jpg)

  gallery_omgeving =
    ~w(hilgelo-meer.jpg hilgelo-mee2r.jpg hilgelomeer3.jpg vakantiewoning-hilgelo-meer5.jpg
       vakantiewoning-hilgelo-meer7.jpg Luchtfoto-vakantie-woningen.jpg
       Luchtfoto-vakantie-woningen-2.jpg)

  floorplans =
    [
      {"Platte-grond-begane-grond.jpg", "Plattegrond begane grond"},
      {"Platte-grond-verdieping.jpg", "Plattegrond verdieping"}
    ]

  Enum.each(singles, &Repo.insert!(Image.changeset(%Image{}, &1)))

  gallery_accommodatie
  |> Enum.with_index(1)
  |> Enum.each(fn {file, i} ->
    Repo.insert!(
      Image.changeset(%Image{}, %{
        collection: "gallery_accommodatie",
        path: p.(file),
        alt: "Vakantiewoning Ons Plekkie",
        position: i
      })
    )
  end)

  gallery_omgeving
  |> Enum.with_index(1)
  |> Enum.each(fn {file, i} ->
    Repo.insert!(
      Image.changeset(%Image{}, %{
        collection: "gallery_omgeving",
        path: p.(file),
        alt: "Omgeving Hilgelo meer",
        position: i
      })
    )
  end)

  floorplans
  |> Enum.with_index(1)
  |> Enum.each(fn {{file, caption}, i} ->
    Repo.insert!(
      Image.changeset(%Image{}, %{
        collection: "floorplans",
        path: p.(file),
        alt: caption,
        caption: caption,
        position: i
      })
    )
  end)

  IO.puts("Seeded images.")
else
  IO.puts("Images already present — skipping image seed.")
end
