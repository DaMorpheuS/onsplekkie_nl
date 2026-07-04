defmodule OnsplekkieNl.Uploads do
  @moduledoc """
  Stores uploaded image files under `priv/static/uploads` and returns the web
  path used to serve them.
  """

  @allowed_ext ~w(.jpg .jpeg .png .webp .gif)

  @doc "Absolute path to the uploads directory."
  def dir do
    Path.join(Application.app_dir(:onsplekkie_nl, "priv/static"), "uploads")
  end

  @doc """
  Saves a `%Plug.Upload{}` to the uploads directory. Returns `{:ok, web_path}`
  where `web_path` is like `/uploads/keuken-a1b2c3.jpg`.
  """
  def save(%Plug.Upload{filename: filename, path: tmp_path}) do
    ext = filename |> Path.extname() |> String.downcase()

    if ext in @allowed_ext do
      name = unique_name(filename, ext)
      File.mkdir_p!(dir())
      dest = Path.join(dir(), name)

      case File.cp(tmp_path, dest) do
        :ok -> {:ok, "/uploads/#{name}"}
        {:error, reason} -> {:error, reason}
      end
    else
      {:error, :invalid_type}
    end
  end

  def save(_), do: {:error, :no_file}

  @doc "Deletes the file backing a web path, but only within /uploads."
  def delete(<<"/uploads/", name::binary>>) do
    path = Path.join(dir(), Path.basename(name))
    _ = File.rm(path)
    :ok
  end

  def delete(_), do: :ok

  defp unique_name(filename, ext) do
    base =
      filename
      |> Path.rootname()
      |> Path.basename()
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9]+/, "-")
      |> String.trim("-")
      |> String.slice(0, 40)

    base = if base == "", do: "image", else: base
    rand = Base.url_encode64(:crypto.strong_rand_bytes(6), padding: false)
    "#{base}-#{rand}#{ext}"
  end
end
