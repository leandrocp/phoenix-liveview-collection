import Config

config :live_view_collection, LiveViewCollectionWeb.Endpoint,
  server: true,
  url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443]
