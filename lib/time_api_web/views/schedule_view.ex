defmodule TimeManagerWeb.ScheduleView do
  use TimeManagerWeb, :view
  alias TimeManagerWeb.ScheduleView

  def render("index.json", %{schedules: schedules}) do
    %{data: render_many(schedules, ScheduleView, "schedule.json")}
  end

  def render("show.json", %{schedule: schedule}) do
    %{data: render_one(schedule, ScheduleView, "schedule.json")}
  end

  def render("schedule.json", %{schedule: schedule}) do
    %{id: schedule.id,
      title: schedule.title,
      start: schedule.start,
      end: schedule.end,
      description: schedule.description}
  end
end
