defmodule OnsplekkieNl.Content do
  @moduledoc """
  The Content context: editable text settings and managed images that drive
  the public website and are maintained through the admin backend.
  """

  import Ecto.Query, warn: false
  alias OnsplekkieNl.Repo
  alias OnsplekkieNl.Content.{Setting, Image}

  @default_locale "nl"

  ## Settings

  @doc """
  Returns a `%{key => value}` map for the given locale. Values missing (or blank)
  in the requested locale fall back to the Dutch value.
  """
  def settings_map(locale \\ @default_locale) do
    rows = Repo.all(Setting)

    base = for s <- rows, s.locale == @default_locale, into: %{}, do: {s.key, s.value}

    overlay =
      for s <- rows,
          s.locale == locale,
          s.value not in [nil, ""],
          into: %{},
          do: {s.key, s.value}

    Map.merge(base, overlay)
  end

  @doc "Raw `%{key => value}` map for exactly one locale (no fallback). For the admin editor."
  def settings_raw(locale) do
    Repo.all(from s in Setting, where: s.locale == ^locale)
    |> Map.new(fn s -> {s.key, s.value} end)
  end

  @doc "Fetch a single setting value by key/locale, falling back to Dutch, then `default`."
  def get_setting(key, default \\ "", locale \\ @default_locale) do
    settings_map(locale) |> Map.get(key, default)
  end

  def list_settings(locale \\ @default_locale) do
    Repo.all(from s in Setting, where: s.locale == ^locale, order_by: s.key)
  end

  @doc "Insert or update a setting by key within a locale."
  def put_setting(key, value, locale \\ @default_locale) do
    case Repo.get_by(Setting, key: key, locale: locale) do
      nil -> %Setting{key: key, locale: locale}
      setting -> setting
    end
    |> Setting.changeset(%{key: key, locale: locale, value: value})
    |> Repo.insert_or_update()
  end

  @doc "Bulk update settings from a `%{key => value}` map within a locale."
  def update_settings(params, locale \\ @default_locale) when is_map(params) do
    Enum.each(params, fn {key, value} -> put_setting(key, value, locale) end)
    :ok
  end

  ## Images

  @doc "All images in a collection, ordered by position."
  def list_images(collection) do
    Repo.all(
      from i in Image,
        where: i.collection == ^collection,
        order_by: [asc: i.position, asc: i.id]
    )
  end

  @doc "Returns images grouped into a `%{collection => [images]}` map."
  def images_by_collection do
    Repo.all(from i in Image, order_by: [asc: i.position, asc: i.id])
    |> Enum.group_by(& &1.collection)
  end

  @doc "Fetch a single image by its unique slug (used for hero/featured slots)."
  def get_image_by_slug(slug), do: Repo.get_by(Image, slug: slug)

  def get_image!(id), do: Repo.get!(Image, id)

  def create_image(attrs) do
    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end

  def update_image(%Image{} = image, attrs) do
    image
    |> Image.changeset(attrs)
    |> Repo.update()
  end

  def delete_image(%Image{} = image), do: Repo.delete(image)

  def change_image(%Image{} = image, attrs \\ %{}), do: Image.changeset(image, attrs)

  @doc "Next position value for appending to a collection."
  def next_position(collection) do
    max =
      Repo.one(from i in Image, where: i.collection == ^collection, select: max(i.position)) || 0

    max + 1
  end
end
