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
      team = Store.get_team!(team.id)
      with {:ok, %Team{} = team} <- Store.update_team(team, team_params) do
        render(conn, "show.json", team: team)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    token = conn
            |> get_req_header("token")
    token = List.first(token)
    verifyToken = JsonWebToken.verify(token, %{key: "vv6ez3s6YLppRmMolqNxTVOAZ7DcMRRSalpdNnFm5WLA1DF1lKBxXefxSwKFkN"})
    case verifyToken do
      {:ok, ok} -> affich(conn,id)
      {:error, error} -> conn
                         |> put_resp_content_type("text/plain")
                         |> send_resp(404, "WRONG TOKEN")
    end
  end

  def affich(conn,id) do
  user = Store.get_team!(id)
render(conn, "show.json", user: user)
end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Store.get_team!(id)

    with {:ok, %Team{} = team} <- Store.update_team(team, team_params) do
      render(conn, "show.json", team: team)
    end
  end

end
