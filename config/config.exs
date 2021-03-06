# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :healthlocker,
  ecto_repos: [Healthlocker.Repo]

# Configures the endpoint
config :healthlocker, Healthlocker.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ea7BnffOt5Z35L3NrzDAoCrR9eakAXLVfFEDgw3tpuynIEnF9meMlqGZP1bWT4kI",
  render_errors: [view: Healthlocker.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Healthlocker.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configure mailing
config :healthlocker, Healthlocker.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: System.get_env("SES_SERVER"),
  port: System.get_env("SES_PORT"),
  username: System.get_env("SMTP_USERNAME"),
  password: System.get_env("SMTP_PASSWORD"),
  tls: :always, # can be `:always` or `:never`
  ssl: false, # can be `true`
  retries: 1

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
