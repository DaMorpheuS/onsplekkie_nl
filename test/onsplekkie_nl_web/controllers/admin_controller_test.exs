defmodule OnsplekkieNlWeb.AdminControllerTest do
  use OnsplekkieNlWeb.ConnCase

  test "admin area redirects to login when not authenticated", %{conn: conn} do
    conn = get(conn, ~p"/admin")
    assert redirected_to(conn) == ~p"/admin/login"
  end

  test "login page is public", %{conn: conn} do
    assert conn |> get(~p"/admin/login") |> html_response(200) =~ "Wachtwoord"
  end

  test "logging in with the correct password grants access", %{conn: conn} do
    password = Application.get_env(:onsplekkie_nl, :admin_password)

    conn = post(conn, ~p"/admin/login", %{"password" => password})
    assert redirected_to(conn) == ~p"/admin"

    conn = get(conn, ~p"/admin")
    assert html_response(conn, 200) =~ "Dashboard"
  end

  test "logging in with a wrong password is rejected", %{conn: conn} do
    conn = post(conn, ~p"/admin/login", %{"password" => "wrong"})
    assert html_response(conn, 200) =~ "Onjuist wachtwoord"
  end
end
