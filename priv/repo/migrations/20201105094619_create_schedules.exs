defmodule TimeManager.Repo.Migrations.CreateSchedules do
  use Ecto.Migration

  def change do
    create table(:schedules) do
      add :title, :string
      add :start, :naive_datetime
      add :end, :naive_datetime
      add :cssClass, :string
      add :user_id, references(:users, on_delete: :delete_all)
      timestamps()
    end
    create index(:schedules, [:user_id])

  end
end
