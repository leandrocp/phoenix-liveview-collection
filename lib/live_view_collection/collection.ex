defmodule LiveViewCollection.Collection do
  use Agent
  require Logger
  alias LiveViewCollection.Twitter

  def start_link(_) do
    Agent.start_link(fn -> load_from_file() end, name: __MODULE__)
  end

  def all, do: Agent.get(__MODULE__, fn collection -> collection end)

  def filter(), do: all()
  def filter(query) when query == "" or is_nil(query), do: all()

  def filter(query) do
    {:ok, regex} = Regex.compile(query, "i")

    Agent.get(__MODULE__, fn collection ->
      Enum.filter(collection, fn {name, _} -> String.match?(name, regex) end)
    end)
  end

  def load_from_file do
    {:ok, collection} =
      File.cwd!()
      |> Path.join("collection.yml")
      |> YamlElixir.read_from_file()

    resolve_tweets(collection)
  end

  defp resolve_tweets(collection) do
    resolve_item = fn %{"name" => name, "tweet_url" => tweet_url} ->
      Logger.info("Loading #{name}")
      {name, Twitter.embed_html(tweet_url)}
    end

    collection
    |> Enum.map(&(Task.async(fn -> resolve_item.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end
