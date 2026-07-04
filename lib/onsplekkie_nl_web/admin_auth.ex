defmodule OnsplekkieNlWeb.AdminAuth do
  @moduledoc """
  Simple session-based authentication for the /admin backend. A single shared
  password (configured via `:admin_password`, overridable with the
  `ADMIN_PASSWORD` env var) gates access.
  """
  import Plug.Conn
  import Phoenix.Controller

  @doc "Plug that halts unauthenticated requests to the admin area."
  def require_admin(conn, _opts) do
    if get_session(conn, :admin_authenticated) do
      conn
    else
      conn
      |> put_flash(:error, "Log in om het beheer te openen.")
      |> redirect(to: "/admin/login")
      |> halt()
    end
  end

  @doc "Constant-time comparison of the given password against the configured one."
  def valid_password?(password) do
    expected = Application.get_env(:onsplekkie_nl, :admin_password) || ""
    Plug.Crypto.secure_compare(to_string(password), to_string(expected))
  end

  def log_in(conn) do
    conn
    |> configure_session(renew: true)
    |> put_session(:admin_authenticated, true)
  end

  def log_out(conn) do
    delete_session(conn, :admin_authenticated)
  end
end
