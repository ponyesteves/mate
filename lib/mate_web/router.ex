defmodule MateWeb.Router do
  use MateWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MateWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MateWeb do
    pipe_through :browser
    resources "/accounts", AccountController

    live "/", PageLive, :index
    live "/new", PageLive, :new
    live "/new_outcome", PageLive, :new_outcome
    live "/:account_debit_id/adjust_balance/:account_credit_id/:card", PageLive, :adjust_balance
    live "/:id/move_balance", PageLive, :move_balance
    live "/:id/pay/:source_id", PageLive, :pay
    live "/:id/tag_account/:tag_name", PageLive, :tag_account
    live "/:id/untag_account/:tag_name", PageLive, :untag_account
 end

  # Other scopes may use custom stacks.
  # scope "/api", MateWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: MateWeb.Telemetry
    end
  end
end
