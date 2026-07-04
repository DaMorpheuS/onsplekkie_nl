defmodule OnsplekkieNl.Repo.Migrations.AddStatusToReservations do
  use Ecto.Migration

  def change do
    alter table(:reservations) do
      add :status, :string, null: false, default: "reserved"
    end

    create index(:reservations, [:status])
    create index(:reservations, [:arrival])
  end
end
