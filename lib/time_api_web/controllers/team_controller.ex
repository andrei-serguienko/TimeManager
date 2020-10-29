defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Store
  alias TimeManager.Store.Team

  action_fallback TimeManagerWeb.FallbackController

#  def index(conn, %{"name" => name} = _params) do
#    teams = Store.get_team_by_name(name)
#    render(conn, "index.json", teams: teams)
#  end

  def index(conn, _params) do
    teams = Store.get_teams_link()
    render(conn, "index.json", teams: teams)
  end

  def create(conn, %{"userID" => user_id, "teamID" => team_id}) do
    with {:ok, %Team{} = team} <- Store.link_team_user(user_id, team_id) do
      conn
      |> put_status(:created)
      |> render("show.json", team: team)
    end
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Store.create_team(team_params) do
      conn
      |> put_status(:created)
      |> render("show.json", team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Store.get_team!(id)
    render(conn, "show.json", user: user)
  end

end
