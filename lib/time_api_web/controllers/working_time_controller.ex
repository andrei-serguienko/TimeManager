defmodule TimeManagerWeb.WorkingTimeController do
  use TimeManagerWeb, :controller

  alias TimeManager.Store
  alias TimeManager.Store.WorkingTime

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"userID" => userID, "workingtimeID" => workingtimeID}) do
    workingtime = Store.get_workingtimes_by_user_id_and_working_time_id(userID, workingtimeID)
    render(conn, "index.json", workingtimes: workingtime)
  end

  def index(conn, %{"userID" => userID, "start" => start, "end" => endVal}) do
    workingtime = Store.get_workingtimes_by_start_and_end(userID, start, endVal)
    render(conn, "index.json", workingtimes: workingtime)
  end

  def index(conn, %{"userID" => userID}) do
    workingtime = Store.get_workingtimes_by_user_id(userID)
    render(conn, "index.json", workingtimes: workingtime)
  end

  def index(conn, _params) do
    workingtime = Store.list_workingtimes()
    render(conn, "index.json", workingtimes: workingtime)
  end

  def create(conn, %{"user_id" => user_id, "working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Store.create_working_time(user_id, working_time_params) do
      conn
      |> put_status(:created)
      |> render("show.json", working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Store.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Store.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Store.update_working_time(working_time, working_time_params) do
      render(conn, "show.json", working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Store.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Store.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
