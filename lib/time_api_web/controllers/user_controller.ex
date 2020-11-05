defmodule TimeManagerWeb.UserController do
  use TimeManagerWeb, :controller

  alias TimeManager.Store
  alias TimeManager.Store.User

  require Logger

  action_fallback TimeManagerWeb.FallbackController

  def nolink(conn, %{"id" => id}) do
    TimeManager.VerifyToken.checkToken(conn)
    user = Store.get_user!(id)
    render(conn, "show_without_working.json", user: user)
  end

  def index(conn, %{"username" => username, "email" => email} = _params) do
    TimeManager.VerifyToken.checkToken(conn)
    users = Store.get_users_by_username_and_email!(username, email)
    render(conn, "index.json", users: users)
  end

  def index(conn, %{"email" => email} = _params) do
    TimeManager.VerifyToken.checkToken(conn)
    users = Store.get_users_by_email!(email)
    render(conn, "index.json", users: users)
  end

  def index(conn, %{"username" => username} = _params) do
    TimeManager.VerifyToken.checkToken(conn)
    users = Store.get_users_by_username!(username)
    render(conn, "index.json", users: users)
  end

  def index(conn, _params) do
    TimeManager.VerifyToken.checkToken(conn)
    user = Store.list_users()
    render(conn, "index_with_working.json", users: user)
  end

  def single(conn, %{"id" => id}) do
    TimeManager.VerifyToken.checkToken(conn)
    users = Store.get_user_id!(id)
    render(conn, "index_with_working.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    Enum.map(user_params, fn {k, v} ->
      if k == "admin" do
        if v == true do
          TimeManager.VerifyToken.checkToken(conn)
        end
      end
    end)

    with {:ok, %User{} = user} <- Store.create_user(user_params) do
      jwt = JsonWebToken.sign(
        %{userId: user.id, isAdmin: user.admin},
        %{key: "vv6ez3s6YLppRmMolqNxTVOAZ7DcMRRSalpdNnFm5WLA1DF1lKBxXefxSwKFkN"}
      )
      conn
      |> put_status(201)
      |> render("token.json", token: jwt)
    end
  end

  def show(conn, %{"id" => id}) do
    TimeManager.VerifyToken.checkToken(conn)
    affich(conn,id)
  end

  def affich(conn,id) do
    TimeManager.VerifyToken.checkToken(conn)
    user = Store.get_user!(id)
    render(conn, "show_without_working.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    TimeManager.VerifyToken.checkToken(conn)

    with {:ok, %User{} = user} <- Store.update_user(id, user_params) do
      render(conn, "show_without_working.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    TimeManager.VerifyToken.checkToken(conn)
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
end
