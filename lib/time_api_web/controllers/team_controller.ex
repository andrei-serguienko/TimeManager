defmodule TimeManagerWeb.TeamController do
  use TimeManagerWeb, :controller

  alias TimeManager.Store
  alias TimeManager.Store.Team

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"userID" => user_id}) do
    teams = Store.get_user_in_team(user_id)
    render(conn, "index.json", teams: teams)
  end

  def index(conn, _params) do
    teams = Store.get_teams_link()
    render(conn, "index.json", teams: teams)
  end

  def delete(conn, %{"id" => id}) do
    team = Store.get_team!(id)
    with {:ok, %Team{}} <- Store.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end

  def authentication(conn, %{"teamID" => id}) do
    team = Store.get_team!(id)
    if(team) do
      send_resp(conn, :created, "")
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
      affich(conn,id)
  end

  def affich(conn,id) do
    team = Store.get_team!(id)
    render(conn, "show.json", team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Store.get_team!(id)

    with {:ok, %Team{} = team} <- Store.update_team(team, team_params) do
      render(conn, "show.json", team: team)
    end
  end

end
