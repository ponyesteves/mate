# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :mate,
  ecto_repos: [Mate.Repo]

# Configures the endpoint
config :mate, MateWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "3dQW5IhjJLut3oVnSNUvrd6ZTRMzCDSC7HXRWsKApDMfUxZ9KCc1k1aNep33gM7Y",
  render_errors: [view: MateWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mate.PubSub,
  live_view: [signing_salt: "OoJqDlZr"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :mate, MateWeb.Gettext, locales: ~w(es), default_locale: "es"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
