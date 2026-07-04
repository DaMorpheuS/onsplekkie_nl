defmodule OnsplekkieNl.Repo.Migrations.CreateBlockedPeriods do
  use Ecto.Migration

  def change do
    create table(:blocked_periods) do
      add :start_date, :date, null: false
      add :end_date, :date, null: false
      add :reason, :string

      timestamps(type: :utc_datetime)
    end

    create index(:blocked_periods, [:start_date])
  end
end
