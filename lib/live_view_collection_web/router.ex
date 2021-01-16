defmodule LiveViewCollectionWeb.Router do
  use LiveViewCollectionWeb, :router

  @content_security_policy %{
    "default-src" => ~w[
      'self'
      https://platform.twitter.com
    ],
    "connect-src" => ~w[
      'self'
      ws://localhost:*
      wss://localhost:*
      https://live-view-collection.herokuapp.com/
      wss://live-view-collection.herokuapp.com/
      wss://phx-live-view-collection.gigalixirapp.com
      https://phx-live-view-collection.gigalixirapp.com
    ],
    "img-src" => ~w[
      'self'
      data:
      https://cdn.jsdelivr.net
      https://gh-card.dev
    ],
    "script-src" => ~w[
      'self'
      'unsafe-inline'
      'unsafe-eval'
      https://platform.twitter.com
    ],
    "style-src" => ~w[
      'self'
      'unsafe-inline'
    ],
    "font-src" => ~w[
      'self'
    ],
    "object-src" => ~w[
      'none'
    ]
  }

  pipeline :browser do
    plug LiveViewCollectionWeb.Plugs.RedirectToGigalixir
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {LiveViewCollectionWeb.LayoutView, :root}
    plug :protect_from_forgery

    plug :put_secure_browser_headers, %{
      "content-security-policy" =>
        Enum.map_join(@content_security_policy, " ", fn {k, v} -> "#{k} #{Enum.join(v, " ")};" end)
    }
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveViewCollectionWeb do
    pipe_through :browser

    live "/", CollectionLive
  end
end
