defmodule TimeManager.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string, null: false
      add :email, :string, null: false
      add :admin, :boolean, default: false
      add :password_hash, :string, null: false
      add :manager_id, references(:teams, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:users, [:email])
    create index(:users, [:manager_id])
  end
end
