defmodule OnsplekkieNlWeb.AdminImageController do
  use OnsplekkieNlWeb, :controller

  alias OnsplekkieNl.Content
  alias OnsplekkieNl.Uploads

  # {collection, label, kind} — :single = one featured slot, :gallery = many.
  @collections [
    {"hero", "Home — hero achtergrond", :single},
    {"home_intro", "Home — intro afbeelding", :single},
    {"home_accommodatie", "Home — accommodatie afbeelding", :single},
    {"omgeving_hero", "Omgeving — hoofdafbeelding", :single},
    {"reserveren_hero", "Reserveren — hoofdafbeelding", :single},
    {"gallery_accommodatie", "Accommodatie — fotogalerij", :gallery},
    {"gallery_omgeving", "Omgeving — fotogalerij", :gallery},
    {"floorplans", "Plattegronden", :gallery}
  ]

  def index(conn, _params) do
    grouped = Content.images_by_collection()

    collections =
      Enum.map(@collections, fn {key, label, kind} ->
        %{key: key, label: label, kind: kind, images: Map.get(grouped, key, [])}
      end)

    render(conn, :index,
      active: :images,
      page_title: "Afbeeldingen",
      collections: collections
    )
  end

  def create(conn, %{"collection" => collection, "image" => image_params}) do
    upload = image_params["file"]

    case Uploads.save(upload) do
      {:ok, web_path} ->
        Content.create_image(%{
          "collection" => collection,
          "path" => web_path,
          "alt" => image_params["alt"] || "",
          "caption" => image_params["caption"] || "",
          "position" => Content.next_position(collection)
        })

        conn
        |> put_flash(:info, "Afbeelding toegevoegd.")
        |> redirect(to: ~p"/admin/images")

      {:error, reason} ->
        conn
        |> put_flash(:error, upload_error(reason))
        |> redirect(to: ~p"/admin/images")
    end
  end

  def update(conn, %{"id" => id, "image" => image_params}) do
    image = Content.get_image!(id)
    upload = image_params["file"]

    attrs = %{
      "alt" => image_params["alt"] || image.alt,
      "caption" => image_params["caption"] || image.caption,
      "position" => image_params["position"] || image.position
    }

    attrs =
      case Uploads.save(upload) do
        {:ok, web_path} ->
          Uploads.delete(image.path)
          Map.put(attrs, "path", web_path)

        {:error, :no_file} ->
          attrs

        {:error, reason} ->
          throw({:upload_error, reason})
      end

    case Content.update_image(image, attrs) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Afbeelding bijgewerkt.")
        |> redirect(to: ~p"/admin/images")

      {:error, _} ->
        conn
        |> put_flash(:error, "Bijwerken mislukt.")
        |> redirect(to: ~p"/admin/images")
    end
  catch
    {:upload_error, reason} ->
      conn
      |> put_flash(:error, upload_error(reason))
      |> redirect(to: ~p"/admin/images")
  end

  def delete(conn, %{"id" => id}) do
    image = Content.get_image!(id)
    Uploads.delete(image.path)
    Content.delete_image(image)

    conn
    |> put_flash(:info, "Afbeelding verwijderd.")
    |> redirect(to: ~p"/admin/images")
  end

  defp upload_error(:invalid_type),
    do: "Ongeldig bestandstype. Gebruik jpg, png, webp of gif."

  defp upload_error(:no_file), do: "Geen bestand gekozen."
  defp upload_error(_), do: "Uploaden mislukt."
end
