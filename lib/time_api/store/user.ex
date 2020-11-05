defmodule TimeManager.Store.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string
    field :admin, :boolean
    field :password_hash, :string
    has_many :workingtimes, TimeManager.Store.WorkingTime, on_delete: :delete_all
    has_many :clocks, TimeManager.Store.Clock, on_delete: :delete_all
    has_many :schedules, TimeManager.Store.Schedule, on_delete: :delete_all

    many_to_many(
      :teams,
      TimeManager.Store.Team,
      join_through: TimeManager.Store.TeamUser,
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :admin, :password_hash])
    |> validate_required([:username, :email, :password_hash])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
