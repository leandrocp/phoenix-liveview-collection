defmodule LiveViewCollection.Collection do
  use Agent
  require Logger
  alias LiveViewCollection.Twitter
  alias LiveViewCollection.Github

  @default_query ""
  @default_page 1
  @default_page_size 10

  def start_link(_) do
    collection = if Mix.env() == :test, do: [], else: load_from_file()

    Agent.start_link(fn -> collection end, name: __MODULE__)
  end

  def all, do: Agent.get(__MODULE__, fn collection -> collection end)

  def filter(query \\ @default_query) do
    Agent.get(__MODULE__, &do_filter(&1, query))
  end

  def resolve(query \\ @default_query, page \\ @default_page, page_size \\ @default_page_size) do
    Agent.get(__MODULE__, fn collection ->
      collection
      |> do_filter(query)
      |> do_paginate(page, page_size)
    end)
  end

  def load_from_file do
    {:ok, collection} =
      YamlElixir.read_from_file(Application.get_env(:live_view_collection, :collection_yml_path))

    collection
    |> Twitter.resolve()
    |> Github.resolve()
    |> resolve_search_field()
  end

  defp do_filter(collection, query) when is_nil(query) or query == "", do: collection

  defp do_filter(collection, query) do
    {:ok, regex} = Regex.compile(query, "i")

    Enum.filter(collection, fn %{"search" => search} ->
      String.match?(search, regex)
    end)
  end

  defp do_paginate(collection, page, page_size)
       when is_nil(page) or page <= 0 or is_nil(page_size) or page_size <= 0 do
    do_paginate(collection, @default_page, @default_page_size)
  end

  defp do_paginate(collection, page, page_size) do
    Enum.slice(collection, (page - 1) * page_size, page_size)
  end

  defp resolve_search_field(collection) do
    collection
    |> Enum.map(fn
      %{"name" => name, "tweet_html" => tw_html} = item when is_binary(tw_html) ->
        Map.put(item, "search", name <> " " <> tw_html)

      %{"name" => name} = item ->
        Map.put(item, "search", name)
    end)
  end
end
