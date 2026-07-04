defmodule OnsplekkieNl.BookingsTest do
  use OnsplekkieNl.DataCase, async: true

  alias OnsplekkieNl.Bookings
  alias OnsplekkieNl.Content

  defp days(n), do: Date.add(Date.utc_today(), n)

  defp valid_attrs(arrival, departure) do
    %{
      "first_name" => "Test",
      "last_name" => "Guest",
      "phone" => "0612345678",
      "email" => "guest@example.com",
      "num_persons" => "2",
      "arrival" => Date.to_iso8601(arrival),
      "departure" => Date.to_iso8601(departure)
    }
  end

  test "creating a reservation holds its nights as unavailable" do
    assert {:ok, reservation} = Bookings.create_reservation(valid_attrs(days(10), days(14)))
    assert reservation.status == "reserved"

    # The booked nights are now occupied, but the departure day stays free.
    refute Bookings.available?(days(10), days(14))
    assert Bookings.available?(days(14), days(16))
  end

  test "overlapping reservations are rejected" do
    assert {:ok, _} = Bookings.create_reservation(valid_attrs(days(10), days(14)))
    assert {:error, changeset} = Bookings.create_reservation(valid_attrs(days(12), days(16)))
    assert %{arrival: ["deze periode is niet meer beschikbaar"]} = errors_on(changeset)
  end

  test "past and reversed date ranges are unavailable" do
    refute Bookings.available?(days(-2), days(1))
    refute Bookings.available?(days(10), days(10))
  end

  test "a blocked period blocks those dates" do
    assert {:ok, _} =
             Bookings.create_blocked_period(%{
               "start_date" => Date.to_iso8601(days(20)),
               "end_date" => Date.to_iso8601(days(22)),
               "reason" => "maintenance"
             })

    refute Bookings.available?(days(19), days(21))
    assert Bookings.available?(days(23), days(25))
  end

  test "the computed total price is stored on the reservation" do
    Content.put_setting("price_per_night", "100")
    Content.put_setting("price_cleaning", "50")
    Content.put_setting("price_energy_per_day", "0")
    Content.put_setting("price_tourist_tax_pppd", "0")
    Content.put_setting("price_linen_pp", "10")

    # 3 nights × €100 + €50 cleaning, 2 guests, no linen = €350
    {:ok, reservation} = Bookings.create_reservation(valid_attrs(days(10), days(13)))
    assert Decimal.equal?(reservation.total_price, Decimal.new("350.00"))
  end

  test "cancelling a reservation frees its dates; confirming keeps them held" do
    {:ok, reservation} = Bookings.create_reservation(valid_attrs(days(10), days(14)))

    {:ok, booked} = Bookings.confirm_reservation(reservation)
    assert booked.status == "booked"
    refute Bookings.available?(days(10), days(14))

    {:ok, cancelled} = Bookings.cancel_reservation(booked)
    assert cancelled.status == "cancelled"
    assert Bookings.available?(days(10), days(14))
  end
end
