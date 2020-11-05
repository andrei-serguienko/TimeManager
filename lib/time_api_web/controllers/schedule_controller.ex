defmodule TimeManagerWeb.ScheduleController do
  use TimeManagerWeb, :controller

  alias TimeManager.Store
  alias TimeManager.Store.Schedule

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"userID" => userID}) do
    schedule = Store.get_schedules_by_user_id(userID)
    render(conn, "index.json", schedules: schedule)
  end

  def index(conn, _params) do
    schedules = Store.list_schedules()
    render(conn, "index.json", schedules: schedules)
  end

  def create(conn, %{"user_id" => user_id, "schedule" => schedule_params}) do
    with {:ok, %Schedule{} = schedule} <- Store.create_schedule(user_id, schedule_params) do
      conn
      |> put_status(:created)
      |> render("show.json", schedule: schedule)
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

  def update(conn, %{"id" => id, "schedule" => schedule_params}) do
    schedule = Store.get_schedule!(id)

    with {:ok, %Schedule{} = schedule} <- Store.update_schedule(schedule, schedule_params) do
      render(conn, "show.json", schedule: schedule)
    end
  end

  def affich(conn, id) do
    schedule = Store.get_schedule!(id)
    render(conn, "show.json", schedule: schedule)
  end

  def delete(conn, %{"id" => id}) do
    schedule = Store.get_schedule!(id)

    with {:ok, %Schedule{}} <- Store.delete_schedule(schedule) do
      send_resp(conn, :no_content, "")
    end
  end
  def authentication(conn, %{"id" => id}) do
    working_time = Store.get_working_time!(id)
    if(working_time) do
      send_resp(conn, :created, "")
    end
  end
end
