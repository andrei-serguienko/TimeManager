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

  def index(conn, %{"userID" => userID, "start" => start}) do
    workingtime = Store.get_workingtimes_by_start(userID, start)
    render(conn, "index.json", workingtimes: workingtime)
  end

  def index(conn, %{"userID" => userID, "end" => endVal}) do
    workingtime = Store.get_workingtimes_by_end(userID, endVal)
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

  def affich(conn, id) do
    working_time = Store.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
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

  def authentication(conn, %{"id" => id}) do
    working_time = Store.get_working_time!(id)
    if(working_time) do
      send_resp(conn, :created, "")
    end
  end
end
