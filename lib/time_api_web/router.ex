defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]

  end

  scope "/api", TimeManagerWeb do
    pipe_through :api
    post "/clocks/:user_id", ClockController, :create
    post "/workingtimes/:user_id", WorkingTimeController, :create
    delete "/workingtimes/:id", WorkingTimeController, :delete
    put "/workingtimes/:id", WorkingTimeController, :update
    get "/workingtimes", WorkingTimeController, :index
    get "/workingtimes/:userID", WorkingTimeController, :index
    get "/workingtimes/:userID/:workingtimeID", WorkingTimeController, :index
    get "/clocks/:user_id", ClockController, :index
    resources "/users", UserController, except: [:new, :edit]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: TimeManagerWeb.Telemetry
    end
  end
end
