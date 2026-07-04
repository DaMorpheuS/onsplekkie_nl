defmodule OnsplekkieNlWeb.PageControllerTest do
  use OnsplekkieNlWeb.ConnCase

  test "GET / renders the public site", %{conn: conn} do
    body = conn |> get(~p"/") |> html_response(200)
    assert body =~ "Accommodatie"
    assert body =~ "Reserveren"
  end

  test "GET /accommodatie", %{conn: conn} do
    assert conn |> get(~p"/accommodatie") |> html_response(200) =~ "Foto"
  end

  test "GET /omgeving", %{conn: conn} do
    assert conn |> get(~p"/omgeving") |> html_response(200)
  end

  test "GET /reserveren shows the booking form", %{conn: conn} do
    assert conn |> get(~p"/reserveren") |> html_response(200) =~ "reservation"
  end

  test "GET /contact shows the contact form", %{conn: conn} do
    assert conn |> get(~p"/contact") |> html_response(200) =~ "message"
  end
end
