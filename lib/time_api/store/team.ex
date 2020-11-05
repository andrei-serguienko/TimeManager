defmodule TimeManager.Store.Team do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    many_to_many(
      :users,
      TimeManager.Store.User,
      join_through: TimeManager.Store.TeamUser,
      on_replace: :delete
    )
    has_one :manager, TimeManager.Store.User, on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  def changeset_update_users(%TimeManager.Store.Team{} = team, users) do
    team
    |> cast(%{}, [:name])
    |> put_assoc(:users, users)
  end
end
