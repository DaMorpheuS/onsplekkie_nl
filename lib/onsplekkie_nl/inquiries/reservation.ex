defmodule OnsplekkieNl.Inquiries.Reservation do
  @moduledoc """
  A booking request. Lifecycle via `status`:

    * `"reserved"`  — submitted, holds the dates, awaiting payment
    * `"booked"`    — payment confirmed
    * `"cancelled"` — released, no longer holds the dates
  """
  use Ecto.Schema
  import Ecto.Changeset

  @statuses ~w(reserved booked cancelled)

  def statuses, do: @statuses

  schema "reservations" do
    field :first_name, :string
    field :last_name, :string
    field :phone, :string
    field :email, :string
    field :address, :string
    field :postcode, :string
    field :city, :string
    field :num_persons, :integer
    field :arrival, :date
    field :departure, :date
    field :comments, :string
    field :status, :string, default: "reserved"
    field :handled, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  def changeset(reservation, attrs) do
    reservation
    |> cast(attrs, [
      :first_name,
      :last_name,
      :phone,
      :email,
      :address,
      :postcode,
      :city,
      :num_persons,
      :arrival,
      :departure,
      :comments,
      :status,
      :handled
    ])
    |> validate_required([
      :first_name,
      :last_name,
      :phone,
      :email,
      :num_persons,
      :arrival,
      :departure
    ])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "moet een geldig e-mailadres zijn")
    |> validate_number(:num_persons, greater_than: 0, less_than_or_equal_to: 6)
    |> validate_inclusion(:status, @statuses)
    |> validate_dates()
  end

  defp validate_dates(changeset) do
    arrival = get_field(changeset, :arrival)
    departure = get_field(changeset, :departure)

    cond do
      is_nil(arrival) or is_nil(departure) ->
        changeset

      Date.compare(departure, arrival) != :gt ->
        add_error(changeset, :departure, "moet na de aankomstdatum liggen")

      true ->
        changeset
    end
  end
end
