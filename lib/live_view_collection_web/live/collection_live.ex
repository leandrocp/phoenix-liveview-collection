defmodule LiveViewCollectionWeb.CollectionLive do
  use Phoenix.LiveView
  alias LiveViewCollection.Collection

  def render(assigns) do
    ~L"""
    <form phx-change="search"><input type="text" name="query" value="<%= @query %>" placeholder="Search..." /></form>

    <div id="collection">
      <%= for {name, tweet} <- @collection do %>
        <%= name %>
        <%= Phoenix.HTML.raw(tweet) %>
      <% end %>
    </div>
    """
  end

  def mount(_session, socket) do
    {:ok, assign(socket, collection: Collection.all(), query: nil)}
  end

  def handle_event("search", %{"query" => query}, socket) do
    {:noreply, assign(socket, collection: Collection.filter(query))}
  end
end
