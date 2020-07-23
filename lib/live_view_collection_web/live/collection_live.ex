defmodule LiveViewCollectionWeb.CollectionLive do
  require Logger
  use LiveViewCollectionWeb, :live_view
  alias LiveViewCollection.Collection
  alias LiveViewCollectionWeb.CollectionView

  def render(assigns), do: CollectionView.render("index.html", assigns)

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       collection: Collection.all(),
       collection_size: length(Collection.all()),
       query: "",
       page: 1,
       page_size: 10
     )}
  end

  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, redirect_attrs(socket, query: query, page: 1)}
  end

  def handle_event("goto-page", %{"page" => page}, socket) do
    {:noreply, redirect_attrs(socket, page: String.to_integer(page))}
  end

  def handle_event("change-page-size", %{"page_size" => page_size}, socket) do
    {:noreply, redirect_attrs(socket, page_size: String.to_integer(page_size), page: 1)}
  end

  def handle_params(params, _url, socket) do
    Logger.debug(fn -> "handle_params: #{inspect(params)}" end)

    query = Map.get(params, "query", "")
    page = params |> Map.get("page", "1") |> String.to_integer()
    page_size = params |> Map.get("page_size", "10") |> String.to_integer()
    collection = Collection.resolve(query, page, page_size)

    {:noreply,
     assign(socket, collection: collection, query: query, page: page, page_size: page_size)}
  end

  defp redirect_attrs(socket, attrs) do
    query = attrs[:query] || socket.assigns[:query]
    page = attrs[:page] || socket.assigns[:page]
    page_size = attrs[:page_size] || socket.assigns[:page_size]

    path =
      Routes.live_path(socket, __MODULE__,
        query: query,
        page: page,
        page_size: page_size
      )

    push_patch(socket, to: path)
  end
end
