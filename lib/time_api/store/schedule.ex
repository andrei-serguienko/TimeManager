defmodule TimeManager.Store.Schedule do
  use Ecto.Schema
  import Ecto.Changeset

  schema "schedules" do
    field :title, :string
    field :end, :naive_datetime
    field :start, :naive_datetime
    field :description, :string
    belongs_to :user , TimeManager.Store.User

    timestamps()
  end

  @doc false
  def changeset(schedule, attrs) do
    schedule
    |> cast(attrs, [:title,:start, :end, :description, :user_id])
    |> validate_required([:title,:start, :end, :user_id])
  end
end
