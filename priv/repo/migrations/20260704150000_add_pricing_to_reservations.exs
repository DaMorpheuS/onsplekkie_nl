defmodule OnsplekkieNl.Repo.Migrations.AddPricingToReservations do
  use Ecto.Migration

  def change do
    alter table(:reservations) do
      add :linen, :boolean, null: false, default: false
      add :total_price, :decimal
    end
  end
end
