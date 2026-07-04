defmodule OnsplekkieNlWeb.AdminInboxController do
  use OnsplekkieNlWeb, :controller

  alias OnsplekkieNl.Inquiries

  def index(conn, _params) do
    render(conn, :index,
      active: :inbox,
      page_title: "Aanvragen",
      reservations: Inquiries.list_reservations(),
      messages: Inquiries.list_messages()
    )
  end

  def toggle_reservation(conn, %{"id" => id}) do
    id |> Inquiries.get_reservation!() |> Inquiries.toggle_reservation_handled()

    conn
    |> put_flash(:info, "Status bijgewerkt.")
    |> redirect(to: ~p"/admin/inbox")
  end

  def delete_reservation(conn, %{"id" => id}) do
    id |> Inquiries.get_reservation!() |> Inquiries.delete_reservation()

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
