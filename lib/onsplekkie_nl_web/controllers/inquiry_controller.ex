defmodule OnsplekkieNlWeb.InquiryController do
  use OnsplekkieNlWeb, :controller

  alias OnsplekkieNl.Bookings
  alias OnsplekkieNl.Content
  alias OnsplekkieNl.Inquiries
  alias OnsplekkieNlWeb.I18n

  def create_reservation(conn, %{"reservation" => params}) do
    case Bookings.create_reservation(params) do
      {:ok, _reservation} ->
        conn
        |> put_flash(:info, I18n.t(conn.assigns.locale, "flash.reservation_ok"))
        |> redirect(to: ~p"/reserveren")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> assign(:active, :reserveren)
        |> assign(:page_title, "Reserveren")
        |> assign(:hero, Content.get_image_by_slug("reserveren_hero"))
        |> assign(:occupied, Bookings.occupied_night_strings())
        |> assign(:today, Date.utc_today())
        |> assign(:changeset, changeset)
        |> render(OnsplekkieNlWeb.PageHTML, :reserveren)
    end
  end

  def create_message(conn, %{"message" => params}) do
    case Inquiries.create_message(params) do
      {:ok, _message} ->
        conn
        |> put_flash(:info, I18n.t(conn.assigns.locale, "flash.message_ok"))
        |> redirect(to: ~p"/contact")

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> assign(:active, :contact)
        |> assign(:page_title, "Contact")
        |> assign(:changeset, changeset)
        |> render(OnsplekkieNlWeb.PageHTML, :contact)
    end
  end
end
