defmodule TimeManagerWeb.TeamView do
  use TimeManagerWeb, :view
  alias TimeManagerWeb.TeamView

  def render("index.json", %{teams: teams}) do
    %{data: render_many(teams, TeamView, "team_user.json")}
  end

  def render("show.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team_user.json")}
  end

  def render("show_without_users.json", %{team: team}) do
    %{data: render_one(team, TeamView, "team.json")}
  end

  def render("team_user.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
      users: render_many(team.users, TimeManagerWeb.UserView, "user.json"),
#      manager: render_one(team.manager, TimeManagerWeb.UserView, "user.json")
    }
  end

  def render("team.json", %{team: team}) do
    %{
      id: team.id,
      name: team.name,
    }
  end
end
