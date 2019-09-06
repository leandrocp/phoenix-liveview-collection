defmodule LiveViewCollectionWeb.CollectionView do
  require Logger
  use LiveViewCollectionWeb, :view
  alias LiveViewCollection.Collection

  def number_of_pages(%{query: query, page_size: page_size}) do
    collection_length = query |> Collection.filter() |> length()
    pages = (collection_length / page_size) |> Float.ceil() |> round()
    if pages <= 1, do: [1], else: 1..pages
  end

  def demo_url(%{"demo_url" => demo_url}) when is_nil(demo_url), do: ""

  def demo_url(%{"demo_url" => demo_url}) do
    content_tag(:h4, class: "subtitle is-size-7") do
      link(demo_url, to: demo_url, target: "_blank")
    end
  end

  def demo_url(_), do: ""

  def image(%{"image" => image}, _socket) when is_nil(image), do: ""

  def image(%{"image" => image}, socket) do
    socket
    |> Routes.static_path("/images/demo/#{image}")
    |> img_tag(style: "width: 499px")
  end

  def image(_, _), do: ""
end
