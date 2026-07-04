defmodule OnsplekkieNlWeb.AdminAgendaController do
  use OnsplekkieNlWeb, :controller

  alias OnsplekkieNl.Bookings

  def index(conn, _params) do
    render(conn, :index,
      active: :agenda,
      page_title: "Agenda",
      occupied: Bookings.occupied_night_strings(),
      today: Date.utc_today(),
      blocks: Bookings.list_blocked_periods(),
      upcoming: Bookings.upcoming_reservations()
    )
  end

  def create_block(conn, %{"blocked_period" => params}) do
    case Bookings.create_blocked_period(params) do
      {:ok, _block} ->
        conn
        |> put_flash(:info, "Periode geblokkeerd.")
        |> redirect(to: ~p"/admin/agenda")

      {:error, changeset} ->
        msg =
          changeset.errors
          |> Enum.map(fn {field, {m, _}} -> "#{field} #{m}" end)
          |> Enum.join(", ")

        conn
        |> put_flash(:error, "Kon periode niet blokkeren: #{msg}")
        |> redirect(to: ~p"/admin/agenda")
    end
  end

  def delete_block(conn, %{"id" => id}) do
    id |> Bookings.get_blocked_period!() |> Bookings.delete_blocked_period()

    conn
    |> put_flash(:info, "Blokkade verwijderd.")
    |> redirect(to: ~p"/admin/agenda")
  end
end
