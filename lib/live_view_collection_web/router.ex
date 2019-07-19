defmodule LiveViewCollectionWeb.Router do
  use LiveViewCollectionWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug Phoenix.LiveView.Flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LiveViewCollectionWeb do
    pipe_through :browser

    live "/", CollectionLive
  end
end
