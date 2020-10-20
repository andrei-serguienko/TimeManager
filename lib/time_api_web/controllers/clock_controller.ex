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
      if(clock_params["status"] == false) do
        clockIn = Store.get_clockIn(user_id)
        Store.create_clock(user_id, {clockIn.start, clock_params.time})
       # Store.update_working_time(user_id,{clockIn.start,clock_params.end})
      end
      conn
      |> put_status(:created)
      |> render("show.json", clock: clock)
    end
  end

  def show(conn, %{"id" => id}) do
    clock = Store.get_clock!(id)
    render(conn, "show.json", clock: clock)
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
end
