defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Store
  alias TimeManager.Store.User

  require Logger

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

  def single(conn, %{"id" => id}) do
    users = Store.get_user_id!(id)
    render(conn, "index_with_working.json", users: users)
  end

  def index(conn, _params) do
    users = Store.list_users()
    render(conn, "index_with_working.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Store.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_path(conn, :show, user))
      |> render("show_without_working.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    token = conn
            |> get_req_header("authorization")
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
    user = Store.get_user!(id)
    render(conn, "show_without_working.json", user: user)
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

  def authentication(conn, %{"id" => id}) do
    user = Store.get_user!(id)
    if(user) do
      send_resp(conn, :created, "")
    end
  end

  def signIn(conn, %{"email" => email, "password_hash" => password_hash}) do

    user = Store.get_user_by_email_and_password!(email, password_hash)
    jwt = JsonWebToken.sign(
      %{userId: user.id, isAdmin: user.admin},
      %{key: "vv6ez3s6YLppRmMolqNxTVOAZ7DcMRRSalpdNnFm5WLA1DF1lKBxXefxSwKFkN"}
    )

    if(user) do
      conn
      |> put_status(200)
      |> render("token.json", token: jwt)
    else
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(404, "WRONG")
    end
  end

  defp blank?(str_or_nil),
       do: "" == str_or_nil
                 |> to_string()
                 |> String.trim()
end
