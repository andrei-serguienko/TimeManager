defmodule TimeManager.Store.TeamUser do
  use Ecto.Schema
  import Ecto.Changeset

  alias TimeManager.Store.User
  alias TimeManager.Store.Team

  @already_exists "ALREADY_EXISTS"

  @primary_key false
  schema "team_user" do
    belongs_to(:user, User, primary_key: true)
    belongs_to(:team, Team, primary_key: true)

    timestamps()
  end

  @required_fields ~w(user_id team_id)a
  def changeset(team_user, params \\ %{}) do
    team_user
    |> cast(params, @required_fields)
    |> unique_constraint([:user, :team],
         name: :user_id_team_id_unique_index,
         message: @already_exists
       )
  end
end
