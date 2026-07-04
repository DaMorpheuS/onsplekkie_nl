defmodule OnsplekkieNlWeb.AdminAgendaHTML do
  use OnsplekkieNlWeb, :html

  embed_templates "admin_agenda_html/*"

  def fmt(nil), do: "—"
  def fmt(%Date{} = d), do: Calendar.strftime(d, "%d-%m-%Y")

  def status_label("reserved"), do: "Gereserveerd"
  def status_label("booked"), do: "Geboekt"
  def status_label("cancelled"), do: "Geannuleerd"
  def status_label(other), do: other

  def status_class("reserved"), do: "bg-amber-100 text-amber-800"
  def status_class("booked"), do: "bg-green-100 text-green-800"
  def status_class("cancelled"), do: "bg-gray-100 text-gray-500"
  def status_class(_), do: "bg-gray-100 text-gray-600"

  def money(nil), do: "—"

  def money(%Decimal{} = d) do
    "€ " <> (d |> Decimal.round(2) |> Decimal.to_string() |> String.replace(".", ","))
  end
end
