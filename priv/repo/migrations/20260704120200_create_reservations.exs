defmodule OnsplekkieNl.Repo.Migrations.CreateReservations do
  use Ecto.Migration

  def change do
    create table(:reservations) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :phone, :string, null: false
      add :email, :string, null: false
      add :address, :string
      add :postcode, :string
      add :city, :string
      add :num_persons, :integer
      add :arrival, :date
      add :departure, :date
      add :comments, :text
      add :handled, :boolean, null: false, default: false

      timestamps(type: :utc_datetime)
    end
  end
end
