defmodule TimeManagerWeb.UserView do
  use TimeManagerWeb, :view
  alias TimeManagerWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("index_with_working.json", %{users: users}) do
    %{data: render_many(users, UserView, "user_working.json")}
  end

  def render("show_without_working.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user_working.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      admin: user.admin || false,
      password_hash: user.password_hash
    }
  end

  def render("user_working.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      admin: user.admin || false,
      password_hash: user.password_hash,
      schedules: render_many(user.schedules, TimeManagerWeb.ScheduleView, "schedule.json"),
      workingtimes: render_many(user.workingtimes, TimeManagerWeb.WorkingTimeView, "working_time.json"),
      clocks: render_many(user.clocks, TimeManagerWeb.ClockView, "clock.json"),
      teams: render_many(user.teams, TimeManagerWeb.TeamView, "team.json")
    }
  end

  def render("token.json", %{token: token}) do
    %{token: token}
  end
end
