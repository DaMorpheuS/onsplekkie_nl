defmodule OnsplekkieNlWeb.PageController do
  use OnsplekkieNlWeb, :controller

  alias OnsplekkieNl.Bookings
  alias OnsplekkieNl.Content
  alias OnsplekkieNl.Inquiries

  def home(conn, _params) do
    conn
    |> assign(:active, :home)
    |> assign(:page_title, "Home")
    |> assign(:hero, Content.get_image_by_slug("hero"))
    |> assign(:intro_image, Content.get_image_by_slug("home_intro"))
    |> assign(:accommodatie_image, Content.get_image_by_slug("home_accommodatie"))
    |> render(:home)
  end

  def accommodatie(conn, _params) do
    conn
    |> assign(:active, :accommodatie)
    |> assign(:page_title, "Accommodatie")
    |> assign(:gallery, Content.list_images("gallery_accommodatie"))
    |> assign(:floorplans, Content.list_images("floorplans"))
    |> render(:accommodatie)
  end

  def omgeving(conn, _params) do
    conn
    |> assign(:active, :omgeving)
    |> assign(:page_title, "Omgeving")
    |> assign(:hero, Content.get_image_by_slug("omgeving_hero"))
    |> assign(:gallery, Content.list_images("gallery_omgeving"))
    |> render(:omgeving)
  end

  def reserveren(conn, _params) do
    conn
    |> assign(:active, :reserveren)
    |> assign(:page_title, "Reserveren")
    |> assign(:hero, Content.get_image_by_slug("reserveren_hero"))
    |> assign(:occupied, Bookings.occupied_night_strings())
    |> assign(:today, Date.utc_today())
    |> assign(:changeset, Bookings.change_reservation())
    |> render(:reserveren)
  end

  def contact(conn, _params) do
    conn
    |> assign(:active, :contact)
    |> assign(:page_title, "Contact")
    |> assign(:changeset, Inquiries.change_message())
    |> render(:contact)
  end
end
