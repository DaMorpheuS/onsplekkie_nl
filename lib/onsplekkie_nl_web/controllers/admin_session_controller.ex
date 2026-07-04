defmodule OnsplekkieNlWeb.AdminSessionController do
  use OnsplekkieNlWeb, :controller

  alias OnsplekkieNlWeb.AdminAuth

  def new(conn, _params) do
    render(conn, :new, page_title: "Inloggen")
  end

  def create(conn, %{"password" => password}) do
    if AdminAuth.valid_password?(password) do
      conn
      |> AdminAuth.log_in()
      |> put_flash(:info, "Welkom terug!")
      |> redirect(to: ~p"/admin")
    else
      conn
      |> put_flash(:error, "Onjuist wachtwoord.")
      |> render(:new, page_title: "Inloggen")
    end
  end

  def delete(conn, _params) do
    conn
    |> AdminAuth.log_out()
    |> put_flash(:info, "U bent uitgelogd.")
    |> redirect(to: ~p"/admin/login")
  end
end
