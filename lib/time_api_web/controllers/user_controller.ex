defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Store
  alias TimeManager.Store.User

  action_fallback TimeManagerWeb.FallbackController

  def index(conn, %{"username" => username, "email" => email} = _params) do
    users = Store.get_users_by_username_and_email!(username, email)
    render(conn, "index.json", users: users)
  end

  def index(conn, %{"email" => email} = _params) do
    users = Store.get_users_by_email!(email)
    render(conn, "index.json", users: users)
  end

  def index(conn, %{"username" => username} = _params) do
    users = Store.get_users_by_username!(username)
    render(conn, "index.json", users: users)
  end

  def index(conn, _params) do
    users = Store.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Store.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Store.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Store.get_user!(id)

    with {:ok, %User{} = user} <- Store.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Store.get_user!(id)

    with {:ok, %User{}} <- Store.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
