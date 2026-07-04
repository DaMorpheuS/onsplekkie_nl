defmodule OnsplekkieNlWeb.AdminInboxController do
  use OnsplekkieNlWeb, :controller

  alias OnsplekkieNl.Bookings
  alias OnsplekkieNl.Inquiries

  def index(conn, _params) do
    render(conn, :index,
      active: :inbox,
      page_title: "Aanvragen",
      reservations: Bookings.list_reservations(),
      messages: Inquiries.list_messages()
    )
  end

  def confirm_reservation(conn, %{"id" => id}) do
    id |> Bookings.get_reservation!() |> Bookings.confirm_reservation()

    conn
    |> put_flash(:info, "Reservering bevestigd als geboekt.")
    |> redirect(to: ~p"/admin/inbox")
  end

  def cancel_reservation(conn, %{"id" => id}) do
    id |> Bookings.get_reservation!() |> Bookings.cancel_reservation()

    conn
    |> put_flash(:info, "Reservering geannuleerd; de data zijn weer vrij.")
    |> redirect(to: ~p"/admin/inbox")
  end

  def delete_reservation(conn, %{"id" => id}) do
    id |> Bookings.get_reservation!() |> Bookings.delete_reservation()

    conn
    |> put_flash(:info, "Reservering verwijderd.")
    |> redirect(to: ~p"/admin/inbox")
  end

  def toggle_message(conn, %{"id" => id}) do
    id |> Inquiries.get_message!() |> Inquiries.toggle_message_handled()

    conn
    |> put_flash(:info, "Status bijgewerkt.")
    |> redirect(to: ~p"/admin/inbox")
  end

  def delete_message(conn, %{"id" => id}) do
    id |> Inquiries.get_message!() |> Inquiries.delete_message()

    conn
    |> put_flash(:info, "Bericht verwijderd.")
    |> redirect(to: ~p"/admin/inbox")
  end
end
