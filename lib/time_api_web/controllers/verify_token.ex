defmodule TimeManager.VerifyToken do
  use TimeManagerWeb, :controller
  alias TimeManager.Store
  alias TimeManager.Store.User

  require Logger

  def checkToken(conn) do
    token = conn |> get_req_header("authorization")
    if token == "" do
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(403, "NO TOKEN")
    else
      token = List.first(token)
      verifyToken = JsonWebToken.verify(token, %{key: "vv6ez3s6YLppRmMolqNxTVOAZ7DcMRRSalpdNnFm5WLA1DF1lKBxXefxSwKFkN"})
      case verifyToken do
        {:ok, ok} -> true
        {:error, error} -> conn
                           |> put_resp_content_type("text/plain")
                           |> send_resp(403, "WRONG TOKEN")
        end
      end
  end
end
