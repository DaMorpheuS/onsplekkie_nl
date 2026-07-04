defmodule OnsplekkieNl.Content.Setting do
  @moduledoc """
  A single editable piece of text content on the site, addressed by a stable
  `key` within a `locale`. Missing translations fall back to Dutch ("nl").
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "settings" do
    field :key, :string
    field :locale, :string, default: "nl"
    field :value, :string, default: ""

    timestamps(type: :utc_datetime)
  end

  def changeset(setting, attrs) do
    setting
    |> cast(attrs, [:key, :locale, :value])
    |> validate_required([:key, :locale])
    |> unique_constraint([:key, :locale], name: :settings_key_locale_index)
  end
end
