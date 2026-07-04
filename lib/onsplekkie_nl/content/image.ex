defmodule OnsplekkieNl.Content.Image do
  @moduledoc """
  A managed image. `collection` groups images (e.g. "hero", "gallery_accommodatie"),
  `path` is the web path served under priv/static, and `position` orders galleries.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :collection, :string
    field :slug, :string
    field :path, :string
    field :alt, :string, default: ""
    field :caption, :string, default: ""
    field :position, :integer, default: 0

    timestamps(type: :utc_datetime)
  end

  def changeset(image, attrs) do
    image
    |> cast(attrs, [:collection, :slug, :path, :alt, :caption, :position])
    |> validate_required([:collection, :path])
    |> unique_constraint(:slug)
  end
end
