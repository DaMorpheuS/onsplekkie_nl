defmodule OnsplekkieNl.Inquiries do
  @moduledoc """
  The Inquiries context: contact messages submitted by visitors, plus the
  notification e-mail to the owners. (Booking reservations live in
  `OnsplekkieNl.Bookings`.)
  """

  import Ecto.Query, warn: false
  alias OnsplekkieNl.Repo
  alias OnsplekkieNl.Inquiries.Message
  alias OnsplekkieNl.Mailer

  import Swoosh.Email, except: [from: 2]

  @owner_email "w.te.nijenhuis@hccnet.nl"

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

    new()
    |> to(@owner_email)
    |> Swoosh.Email.from({"Ons Plekkie website", "no-reply@ons-plekkie.nl"})
    |> subject("Nieuw contactbericht — #{m.first_name}")
    |> text_body(body)
    |> Mailer.deliver()
  rescue
    _ -> :error
  end
end
