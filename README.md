# Ons Plekkie

Website voor vakantiewoning **"Ons Plekkie"** aan het Hilgelo meer in Winterswijk —
een Phoenix-herbouw van [ons-plekkie.nl](https://ons-plekkie.nl) met een eigen beheeromgeving.

## Aan de slag

* Run `mix setup` to install and setup dependencies (creates the DB, runs
  migrations, and seeds all default text + images).
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Structuur

* **Publieke pagina's:** Home, Accommodatie, Omgeving, Reserveren (met boekingsformulier),
  Contact (met contactformulier + kaart). Alle teksten en foto's komen uit de database.
* **Beheer:** [`/admin`](http://localhost:4000/admin). Hier kun je alle teksten aanpassen,
  foto's vervangen/toevoegen/verwijderen en binnengekomen reserverings- en
  contactaanvragen bekijken.
* **Inhoud:** `OnsplekkieNl.Content` (teksten + afbeeldingen) en
  `OnsplekkieNl.Inquiries` (aanvragen). Standaardinhoud staat in `priv/repo/seeds.exs`;
  originele foto's in `priv/static/images/site/`, uploads in `priv/static/uploads/`.

## Beheer-wachtwoord

Het beheer is beveiligd met één gedeeld wachtwoord.

* Standaard (development): `onsplekkie`
* Productie: zet de omgevingsvariabele `ADMIN_PASSWORD`.

Ready to run in production? Please [check our deployment guides](https://phoenix.hexdocs.pm/deployment.html).

## Learn more

* Official website: https://www.phoenixframework.org/
* Guides: https://phoenix.hexdocs.pm/overview.html
* Docs: https://phoenix.hexdocs.pm
* Forum: https://elixirforum.com/c/phoenix-forum
* Source: https://github.com/phoenixframework/phoenix
