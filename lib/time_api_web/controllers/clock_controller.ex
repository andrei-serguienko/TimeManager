defmodule TimeManagerWeb.ClockController do
  use TimeManagerWeb, :controller

  alias TimeManager.Store
  alias TimeManager.Store.Clock

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    clocks = Store.get_clocks_by_user_id(user_id)
    render(conn, "index.json", clocks: clocks)
  end

  def create(conn, %{"user_id" => user_id, "clock" => clock_params}) do
    with {:ok, %Clock{} = clock} <- Store.create_clock(user_id, clock_params) do
      conn
      |> put_status(:created)
      |> render("show.json", clock: clock)
    end
  end

  def affich(conn,  id) do
    clock = Store.get_clock!(id)
    render(conn, "show.json", clock: clock)
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

  def update(conn, %{"id" => id, "clock" => clock_params}) do
    clock = Store.get_clock!(id)

    with {:ok, %Clock{} = clock} <- Store.update_clock(clock, clock_params) do
      render(conn, "show.json", clock: clock)
    end
  end

  def delete(conn, %{"id" => id}) do
    clock = Store.get_clock!(id)

    with {:ok, %Clock{}} <- Store.delete_clock(clock) do
      send_resp(conn, :no_content, "")
    end
  end
  def authentication(conn, %{"id" => id}) do
    clock = Store.get_clock!(id)
    if(clock) do
      send_resp(conn, :created, "")
    end
  end
end
