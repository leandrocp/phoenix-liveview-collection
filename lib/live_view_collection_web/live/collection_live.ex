defmodule LiveViewCollectionWeb.CollectionLive do
  use Phoenix.LiveView
  alias LiveViewCollection.Collection

  def render(assigns) do
    ~L"""
    <form phx-change="search"><input type="text" name="query" value="<%= @query %>" placeholder="Search..." /></form>

    <div id="collection">
      <%= for {name, tweet} <- data(assigns) do %>
        <%= name %>
        <%= Phoenix.HTML.raw(tweet) %>
      <% end %>
    </div>

    <nav class="float-left">
      <%= for page <- number_of_pages(assigns) do %>
        <%= if page == @page do %>
          <strong><%= page %></strong>
        <% else %>
          <a href="#" phx-click="goto-page" phx-value=<%= page %>><%= page %></a>
        <% end %>
      <% end %>
    </nav>

    <form phx-change="change-page-size" class="float-right">
      <select name="page_size">
        <%= for page_size <- [2, 5, 10, 25, 50] do %>
          <option value="<%= page_size %>" <%= page_size == @page_size && "selected" || "" %>>
            <%= page_size %> per page
           </option>
        <% end %>
      </select>
    </form>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, collection: Collection.all(), query: nil, page: 1, page_size: 5)}
  end

  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, redirect_attrs(socket, query: query, page: 1)}
  end

  def handle_event("goto-page", page, socket) do
    {:noreply, redirect_attrs(socket, page: String.to_integer(page))}
  end

  def handle_event("change-page-size", %{"page_size" => page_size}, socket) do
    {:noreply, redirect_attrs(socket, page_size: String.to_integer(page_size), page: 1)}
  end

  def handle_params(params, _url, socket) do
    query = params["query"]
    page = String.to_integer(params["page"] || "1")
    page_size = String.to_integer(params["page_size"] || "5")

    {:noreply, assign(socket, query: query, page: page, page_size: page_size)}
  end

  def data(%{query: query, page: page, page_size: page_size}) do
    query |> Collection.filter() |> paginate(page, page_size)
  end

  defp redirect_attrs(socket, attrs) do
    query = attrs[:query] || socket.assigns[:query]
    page = attrs[:page] || socket.assigns[:page]
    page_size = attrs[:page_size] || socket.assigns[:page_size]
    path = LiveViewCollectionWeb.Router.Helpers.live_path(socket, __MODULE__, query: query, page: page, page_size: page_size)
    live_redirect(socket, to: path)
  end

  defp number_of_pages(%{query: query, page_size: page_size}) do
    collection_length = query |> Collection.filter() |> length()
    pages = trunc(collection_length / page_size)
    if pages <= 1, do: [1], else: 1..pages
  end

  defp paginate(collection, page, page_size), do: collection |> Enum.slice((page - 1) * page_size, page_size)
end
