defmodule OnsplekkieNl.Bookings.BlockedPeriod do
  @moduledoc """
  A period the owner has closed for bookings (e.g. maintenance or private use).
  Both `start_date` and `end_date` are inclusive.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "blocked_periods" do
    field :start_date, :date
    field :end_date, :date
    field :reason, :string

    timestamps(type: :utc_datetime)
  end

  def changeset(period, attrs) do
    period
    |> cast(attrs, [:start_date, :end_date, :reason])
    |> validate_required([:start_date, :end_date])
    |> validate_dates()
  end

  defp validate_dates(changeset) do
    start_date = get_field(changeset, :start_date)
    end_date = get_field(changeset, :end_date)

    if start_date && end_date && Date.compare(end_date, start_date) == :lt do
      add_error(changeset, :end_date, "moet op of na de startdatum liggen")
    else
      changeset
    end
  end
end
