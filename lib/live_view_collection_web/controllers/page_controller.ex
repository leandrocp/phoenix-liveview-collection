defmodule LiveViewCollectionWeb.PageController do
  use LiveViewCollectionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
