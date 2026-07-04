defmodule OnsplekkieNl.Repo.Migrations.AddLocaleToSettings do
  use Ecto.Migration

  def change do
    alter table(:settings) do
      add :locale, :string, null: false, default: "nl"
    end

    drop unique_index(:settings, [:key])
    create unique_index(:settings, [:key, :locale])
  end
end
