defmodule BankApiWeb.Router do
  use BankApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", BankApiWeb do
    pipe_through :api
    post "/auth/signup", UserController, :signup
    get "/user", UserController, :show
    get "/users", UserController, :index
    put "/operations/transfer", OperationController, :transfer
    put "/operations/withdraw", OperationController, :withdraw

    get "/transactions/all", TransactionController, :all
    get "/transactions/year/:year", TransactionController, :year
    get "/transactions/year/:year/month/:month", TransactionController, :month
    get "/transactions/day/:day", TransactionController, :day

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
      live_dashboard "/dashboard", metrics: BankApiWeb.Telemetry
    end
  end
end
