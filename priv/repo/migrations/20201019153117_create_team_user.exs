defmodule TimeManager.Repo.Migrations.CreateTeamUser do
  use Ecto.Migration

  def change do
    create table(:team_user, primary_key: false) do
      add(:team_id, references(:teams, on_delete: :delete_all), primary_key: true)
      add(:user_id, references(:users, on_delete: :delete_all), primary_key: true)
      timestamps()
    end

    create(index(:team_user, [:team_id]))
    create(index(:team_user, [:user_id]))

    create(
      unique_index(:team_user, [:user_id, :team_id], name: :user_id_team_id_unique_index)
    )
  end
end
