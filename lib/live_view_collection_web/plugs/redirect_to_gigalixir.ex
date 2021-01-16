defmodule LiveViewCollectionWeb.Plugs.RedirectToGigalixir do
  @behaviour Plug

  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    if conn.host =~ "heroku" or conn.host =~ "herokuapp" do
      conn
      |> put_status(301)
      |> put_resp_header("location", "https://phx-live-view-collection.gigalixirapp.com")
    else
      conn
    end
  end
end
