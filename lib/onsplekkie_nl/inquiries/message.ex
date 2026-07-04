defmodule OnsplekkieNl.Inquiries.Message do
  @moduledoc "A contact message submitted through the Contact form."
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :first_name, :string
    field :last_name, :string
    field :address, :string
    field :postcode, :string
    field :city, :string
    field :phone, :string
    field :email, :string
    field :question, :string
    field :handled, :boolean, default: false

    timestamps(type: :utc_datetime)
  end

  def changeset(message, attrs) do
    message
    |> cast(attrs, [
      :first_name,
      :last_name,
      :address,
      :postcode,
      :city,
      :phone,
      :email,
      :question,
      :handled
    ])
    |> validate_required([:first_name, :email, :question])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "moet een geldig e-mailadres zijn")
  end
end
