defmodule OnsplekkieNl.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :first_name, :string, null: false
      add :last_name, :string
      add :address, :string
      add :postcode, :string
      add :city, :string
      add :phone, :string
      add :email, :string, null: false
      add :question, :text, null: false
      add :handled, :boolean, null: false, default: false

      timestamps(type: :utc_datetime)
    end
  end
end
