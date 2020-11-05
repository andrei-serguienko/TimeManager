defmodule TimeManagerWeb.Router do
  use TimeManagerWeb, :router

  pipeline :api do
    plug CORSPlug, origin: "*"
    plug :accepts, ["json"]
    plug Corsica, allow_headers: ["authorization"]
  end

  scope "/api", TimeManagerWeb do
    pipe_through :api
    post "/workingtimes/:user_id", WorkingTimeController, :create
    delete "/workingtimes/:id", WorkingTimeController, :delete
    put "/workingtimes/:id", WorkingTimeController, :update
    get "/workingtimes", WorkingTimeController, :index
    get "/workingtimes/:userID", WorkingTimeController, :index
    get "/workingtimes/:userID/:workingtimeID", WorkingTimeController, :index
    options "/workingtimes/:id", WorkingTimeController, :authentication
    options "/workingtimes/:id/:workingtimeID", WorkingTimeController, :authentication


    post "/clocks/:user_id", ClockController, :create
    get "/clocks/:user_id", ClockController, :index
    options "/clocks/:user_id", ClockController, :authentication

    post "/schedules/:userID", ScheduleController, :create
    get "/schedules/:userID", ScheduleController, :index
    options "/schedules/:userID", ScheduleController, :authentication

    resources "/users", UserController, except: [:new, :edit]
    post "/users/sign-in", UserController, :signIn
    get "/user/:id", UserController, :single
    options "/users/:id", UserController, :authentication
    options "/users/", UserController, :authentication
    options "/users/:userID", UserController, :authentication

    resources "/teams", TeamController, except: [:new, :edit]
    #delete "/teams/:teamID", TeamController, :delete
    #get "/teams", TeamController, :index
    #get "/teams/:userID", TeamController, :index
    post "/teams/:userID/:teamID", TeamController, :create
    #post "/teams", TeamController, :create
    post "/teams", TeamController, :create
    put "/teams/:teamID", TeamController, :update
    options "/teams/:userID/:teamID", TeamController, :authentication
    options "/teams/:teamID", TeamController, :authentication
    options "/teams", TeamController, :authentication

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
