defmodule LiveViewCollectionWeb.CollectionView do
  require Logger
  use LiveViewCollectionWeb, :view
  alias LiveViewCollection.Collection

  def render_tweet(tweet_html) do
    Phoenix.HTML.raw(tweet_html)
  end

  def number_of_pages(%{query: query, page_size: page_size}) do
    collection_length = query |> Collection.filter() |> length()
    pages = (collection_length / page_size) |> Float.ceil() |> round()
    if pages <= 1, do: [1], else: 1..pages
  end
end
