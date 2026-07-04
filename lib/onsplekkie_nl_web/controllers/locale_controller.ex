defmodule OnsplekkieNlWeb.LocaleController do
  use OnsplekkieNlWeb, :controller

  alias OnsplekkieNlWeb.I18n

  @doc "Sets the visitor's language in the session and returns to the previous page."
  def update(conn, %{"locale" => locale} = params) do
    locale = if I18n.supported?(locale), do: locale, else: I18n.default_locale()

    conn
    |> put_session(:locale, locale)
    |> redirect(to: return_to(conn, params))
  end

  # Prefer an explicit return_to param, else the referer path; only same-site paths.
  defp return_to(conn, params) do
    (params["return_to"] || referer_path(conn))
    |> safe_path()
  end

  defp referer_path(conn) do
    case get_req_header(conn, "referer") do
      [url | _] -> URI.parse(url).path
      _ -> "/"
    end
  end

  defp safe_path("/" <> _ = path) do
    if String.starts_with?(path, "//"), do: "/", else: path
  end

  defp safe_path(_), do: "/"
end
