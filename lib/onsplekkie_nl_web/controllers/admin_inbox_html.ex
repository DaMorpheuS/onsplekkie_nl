defmodule OnsplekkieNlWeb.AdminInboxHTML do
  use OnsplekkieNlWeb, :html

  embed_templates "admin_inbox_html/*"

  def fmt(nil), do: "—"
  def fmt(%Date{} = d), do: Calendar.strftime(d, "%d-%m-%Y")

  def fmt(%DateTime{} = dt),
    do: Calendar.strftime(dt, "%d-%m-%Y %H:%M")

  def fmt(value), do: to_string(value)

  def present(nil), do: "—"
  def present(""), do: "—"
  def present(v), do: v
end
