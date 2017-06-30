# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Upload configuration for Arc
config :pitanja,
  full_upload_path: Path.expand("./uploads")

# General application configuration
config :pitanja,
  ecto_repos: [Pitanja.Repo]

# Configures the endpoint
config :pitanja, Pitanja.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t+uJVA+tXwahPc1vtPBPjE8Gyom/SBaY5EeAr8cm5a8yBBnK/wx/lDhqStJevLqG",
  render_errors: [view: Pitanja.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Pitanja.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :guardian, Guardian,
  allowed_algos: ["HS512"],
  verify_module: Guardian.JWT,
  issuer: "Pitanja",
  ttl: {30, :days},
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: %{"k" => "5OqToDBrHjejJ-n4g28y89Nv0c3LYd_rOlYm6KiuIR-kuDEgEO7-xne0TjWZhR6Y9GZeT-A8uL-0Ay0kxNqjKQ",
  "kty" => "oct"},
  serializer: Pitanja.GuardianSerializer

config :arc,
  storage: Arc.Storage.Local,
  bucket: "pitanja_bucket",
  virtual_host: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
