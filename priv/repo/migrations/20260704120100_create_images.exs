defmodule OnsplekkieNl.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :collection, :string, null: false
      add :slug, :string
      add :path, :string, null: false
      add :alt, :string, default: ""
      add :caption, :string, default: ""
      add :position, :integer, null: false, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:images, [:collection])
    create unique_index(:images, [:slug])
  end
end
