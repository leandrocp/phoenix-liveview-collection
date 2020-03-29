# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :live_view_collection, LiveViewCollectionWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "yXIQnFB4JlRLfTgs0EFrm71asMhTg8yc1zkIovom1vk0dUyJkFS+kBWfdkPwYiCi",
  render_errors: [view: LiveViewCollectionWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LiveViewCollection.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [
    signing_salt: "sJKdegQfK+A4Fe9vFWhn0JuYKK/+GaRB"
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :live_view_collection, collection_yml_path: Path.join(File.cwd!(), "collection.yml")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
