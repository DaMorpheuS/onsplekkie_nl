defmodule OnsplekkieNl.Inquiries.Reservation do
  @moduledoc "A reservation request submitted through the Reserveren form."
  use Ecto.Schema
  import Ecto.Changeset

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
      :handled
    ])
    |> validate_required([:first_name, :last_name, :phone, :email, :num_persons])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "moet een geldig e-mailadres zijn")
    |> validate_number(:num_persons, greater_than: 0, less_than_or_equal_to: 6)
  end
end
