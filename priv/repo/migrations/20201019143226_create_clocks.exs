defmodule Todolist.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add :time, :naive_datetime
      add :status, :boolean, default: true
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:clocks, [:user_id])
  end
end
