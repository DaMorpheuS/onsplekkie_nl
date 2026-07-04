defmodule OnsplekkieNl.Bookings do
  @moduledoc """
  Availability and the booking lifecycle: guest reservations, their status
  transitions (reserved → booked → cancelled) and owner maintenance blocks.

  Availability is expressed in "nights". A reservation from arrival to departure
  occupies the nights `arrival .. departure - 1` (the departure day is a
  changeover day). A blocked period occupies every day `start_date .. end_date`
  inclusive.
  """

  import Ecto.Query, warn: false
  import Ecto.Changeset, only: [get_field: 2, add_error: 3]

  alias OnsplekkieNl.Repo
  alias OnsplekkieNl.Inquiries.Reservation
  alias OnsplekkieNl.Bookings.BlockedPeriod
  alias OnsplekkieNl.Mailer

  import Swoosh.Email, except: [from: 2]

  @owner_email "w.te.nijenhuis@hccnet.nl"
  @active_statuses ~w(reserved booked)

  ## Availability ----------------------------------------------------------

  @doc "MapSet of `Date` nights that are unavailable (active reservations + blocks)."
  def occupied_nights do
    reservation_nights =
      Reservation
      |> where([r], r.status in @active_statuses)
      |> select([r], {r.arrival, r.departure})
      |> Repo.all()
      |> Enum.flat_map(fn {arrival, departure} ->
        date_range(arrival, Date.add(departure, -1))
      end)

    block_nights =
      BlockedPeriod
      |> select([b], {b.start_date, b.end_date})
      |> Repo.all()
      |> Enum.flat_map(fn {start_date, end_date} -> date_range(start_date, end_date) end)

    MapSet.new(reservation_nights ++ block_nights)
  end

  @doc "Occupied nights as sorted ISO-8601 strings, for the front-end calendar."
  def occupied_night_strings do
    occupied_nights()
    |> Enum.map(&Date.to_iso8601/1)
    |> Enum.sort()
  end

  @doc """
  Whether the nights `arrival .. departure - 1` are all free and not in the past.
  """
  def available?(%Date{} = arrival, %Date{} = departure) do
    nights = date_range(arrival, Date.add(departure, -1))
    occupied = occupied_nights()

    nights != [] and
      Date.compare(arrival, Date.utc_today()) != :lt and
      Enum.all?(nights, &(not MapSet.member?(occupied, &1)))
  end

  def available?(_, _), do: false

  # Inclusive list of dates from `first` to `last` (empty when last < first).
  defp date_range(%Date{} = first, %Date{} = last) do
    case Date.compare(first, last) do
      :gt -> []
      _ -> Date.range(first, last) |> Enum.to_list()
    end
  end

  ## Reservations ----------------------------------------------------------

  def change_reservation(%Reservation{} = reservation \\ %Reservation{}, attrs \\ %{}) do
    Reservation.changeset(reservation, attrs)
  end

  @doc """
  Creates a reservation with status "reserved", but only if the requested
  period is still available. Returns `{:error, changeset}` on conflict.
  """
  def create_reservation(attrs) do
    changeset = Reservation.changeset(%Reservation{}, Map.put_new(attrs, "status", "reserved"))

    cond do
      not changeset.valid? ->
        {:error, %{changeset | action: :insert}}

      not available?(get_field(changeset, :arrival), get_field(changeset, :departure)) ->
        {:error,
         %{
           add_error(changeset, :arrival, "deze periode is niet meer beschikbaar")
           | action: :insert
         }}

      true ->
        with {:ok, reservation} <- Repo.insert(changeset) do
          notify_reservation(reservation)
          {:ok, reservation}
        end
    end
  end

  def list_reservations do
    Repo.all(from r in Reservation, order_by: [asc: r.arrival])
  end

  def upcoming_reservations do
    today = Date.utc_today()

    Repo.all(
      from r in Reservation,
        where: r.status in @active_statuses and r.departure >= ^today,
        order_by: [asc: r.arrival]
    )
  end

  def get_reservation!(id), do: Repo.get!(Reservation, id)

  @doc "Confirm payment: reserved → booked."
  def confirm_reservation(%Reservation{} = reservation), do: set_status(reservation, "booked")

  @doc "Cancel a reservation, releasing its dates."
  def cancel_reservation(%Reservation{} = reservation), do: set_status(reservation, "cancelled")

  defp set_status(%Reservation{} = reservation, status) do
    reservation
    |> Reservation.changeset(%{status: status})
    |> Repo.update()
  end

  def delete_reservation(%Reservation{} = reservation), do: Repo.delete(reservation)

  ## Blocked periods -------------------------------------------------------

  def list_blocked_periods do
    Repo.all(from b in BlockedPeriod, order_by: [asc: b.start_date])
  end

  def change_blocked_period(%BlockedPeriod{} = period \\ %BlockedPeriod{}, attrs \\ %{}) do
    BlockedPeriod.changeset(period, attrs)
  end

  def create_blocked_period(attrs) do
    %BlockedPeriod{} |> BlockedPeriod.changeset(attrs) |> Repo.insert()
  end

  def get_blocked_period!(id), do: Repo.get!(BlockedPeriod, id)

  def delete_blocked_period(%BlockedPeriod{} = period), do: Repo.delete(period)

  ## Notifications ---------------------------------------------------------

  defp notify_reservation(r) do
    body = """
    Nieuwe reserveringsaanvraag via de website:

    Naam: #{r.first_name} #{r.last_name}
    Telefoon: #{r.phone}
    E-mail: #{r.email}
    Adres: #{r.address} #{r.postcode} #{r.city}
    Aantal personen: #{r.num_persons}
    Aankomst: #{r.arrival}
    Vertrek: #{r.departure}
    Status: gereserveerd (in afwachting van betaling)

    Opmerkingen:
    #{r.comments}
    """

    new()
    |> to(@owner_email)
    |> Swoosh.Email.from({"Ons Plekkie website", "no-reply@ons-plekkie.nl"})
    |> subject("Nieuwe reservering — #{r.first_name} #{r.last_name}")
    |> text_body(body)
    |> Mailer.deliver()
  rescue
    _ -> :error
  end
end
