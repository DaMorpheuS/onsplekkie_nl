defmodule OnsplekkieNl.Inquiries do
  @moduledoc """
  The Inquiries context: reservation requests and contact messages submitted
  by visitors, plus notification e-mails to the owners.
  """

  import Ecto.Query, warn: false
  alias OnsplekkieNl.Repo
  alias OnsplekkieNl.Inquiries.{Reservation, Message}
  alias OnsplekkieNl.Mailer

  import Swoosh.Email, except: [from: 2]

  @owner_email "w.te.nijenhuis@hccnet.nl"

  ## Reservations

  def change_reservation(%Reservation{} = reservation \\ %Reservation{}, attrs \\ %{}) do
    Reservation.changeset(reservation, attrs)
  end

  def create_reservation(attrs) do
    with {:ok, reservation} <-
           %Reservation{} |> Reservation.changeset(attrs) |> Repo.insert() do
      notify_reservation(reservation)
      {:ok, reservation}
    end
  end

  def list_reservations do
    Repo.all(from r in Reservation, order_by: [desc: r.inserted_at])
  end

  def get_reservation!(id), do: Repo.get!(Reservation, id)

  def toggle_reservation_handled(%Reservation{} = reservation) do
    reservation
    |> Reservation.changeset(%{handled: !reservation.handled})
    |> Repo.update()
  end

  def delete_reservation(%Reservation{} = reservation), do: Repo.delete(reservation)

  ## Messages

  def change_message(%Message{} = message \\ %Message{}, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def create_message(attrs) do
    with {:ok, message} <- %Message{} |> Message.changeset(attrs) |> Repo.insert() do
      notify_message(message)
      {:ok, message}
    end
  end

  def list_messages do
    Repo.all(from m in Message, order_by: [desc: m.inserted_at])
  end

  def get_message!(id), do: Repo.get!(Message, id)

  def toggle_message_handled(%Message{} = message) do
    message
    |> Message.changeset(%{handled: !message.handled})
    |> Repo.update()
  end

  def delete_message(%Message{} = message), do: Repo.delete(message)

  ## Notifications

  defp notify_reservation(r) do
    body = """
    Nieuwe reserveringsaanvraag via de website:

    Naam: #{r.first_name} #{r.last_name}
    Telefoon: #{r.phone}
    E-mail: #{r.email}
    Adres: #{r.address} #{r.postcode} #{r.city}
    Aantal personen: #{r.num_persons}
    Aankomst: #{r.arrival}
    Vertrek: #{r.departure}

    Opmerkingen:
    #{r.comments}
    """

    deliver("Nieuwe reservering — #{r.first_name} #{r.last_name}", body)
  end

  defp notify_message(m) do
    body = """
    Nieuw contactbericht via de website:

    Naam: #{m.first_name} #{m.last_name}
    Telefoon: #{m.phone}
    E-mail: #{m.email}
    Adres: #{m.address} #{m.postcode} #{m.city}

    Vraag:
    #{m.question}
    """

    deliver("Nieuw contactbericht — #{m.first_name}", body)
  end

  defp deliver(subject, body) do
    new()
    |> to(@owner_email)
    |> Swoosh.Email.from({"Ons Plekkie website", "no-reply@ons-plekkie.nl"})
    |> subject(subject)
    |> text_body(body)
    |> Mailer.deliver()
  rescue
    _ -> :error
  end
end
