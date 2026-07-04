defmodule OnsplekkieNlWeb.Plugs.SiteContent do
  @moduledoc """
  Resolves the active locale (from the session) and assigns the locale plus the
  locale-aware content settings map to every public request, so the shared
  header, footer and pages can render in the chosen language.
  """
  import Plug.Conn

  alias OnsplekkieNlWeb.I18n

  def init(opts), do: opts

  def call(conn, _opts) do
    locale =
      case get_session(conn, :locale) do
        l when is_binary(l) -> if I18n.supported?(l), do: l, else: I18n.default_locale()
        _ -> I18n.default_locale()
      end

    conn
    |> assign(:locale, locale)
    |> assign(:settings, OnsplekkieNl.Content.settings_map(locale))
  end
end
